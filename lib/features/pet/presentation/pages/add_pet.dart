import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart'; // Modern replacement
import 'package:petcare/app/theme/app_colors.dart';
import 'package:petcare/features/pet/domain/usecase/addpet_usecase.dart';
import 'package:petcare/features/pet/presentation/provider/pet_providers.dart';

class AddPet extends ConsumerStatefulWidget {
  const AddPet({super.key});

  @override
  ConsumerState<AddPet> createState() => _AddPetState();
}

class _AddPetState extends ConsumerState<AddPet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedSpecies = 'dog';
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Cache the plugin instance
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      bool hasPermission = await _requestPermission(source);
      if (!hasPermission) {
        if (mounted) _showPermissionDeniedDialog(source);
        return;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<bool> _requestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      return status.isGranted;
    } else {
      // Gallery Permissions
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;

        // Android 13 (SDK 33) and above
        if (androidInfo.version.sdkInt >= 33) {
          // If targeting Android 14+, Permission.photos handles partial access too
          final status = await Permission.photos.request();
          return status.isGranted || status.isLimited;
        } else {
          // Android 12 and below
          final status = await Permission.storage.request();
          return status.isGranted;
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        return status.isGranted || status.isLimited;
      }
    }
    return true;
  }

  void _showPermissionDeniedDialog(ImageSource source) {
    final permissionName = source == ImageSource.camera ? 'Camera' : 'Photos';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permissionName Permission Required'),
        content: Text(
          'Please grant $permissionName permission to select an image for your pet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_imageFile != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _imageFile = null;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Parse age and weight
    final int? age = _ageController.text.isNotEmpty
        ? int.tryParse(_ageController.text)
        : null;

    final double? weight = _weightController.text.isNotEmpty
        ? double.tryParse(_weightController.text)
        : null;

    // Create use case params
    final params = AddPetUsecaseParams(
      name: _nameController.text.trim(),
      species: _selectedSpecies,
      breed: _breedController.text.trim().isEmpty
          ? null
          : _breedController.text.trim(),
      age: age,
      weight: weight,
      imageUrl: _imageFile?.path, // Local file path
    );

    // Call the use case via notifier
    final success = await ref.read(petNotifierProvider.notifier).addPet(params);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } else {
      // Error is already in state
      final error = ref.read(petNotifierProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to add pet'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final petState = ref.watch(petNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Pet'), elevation: 0),
      backgroundColor: AppColors.iconPrimaryColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Pet Image Section
                    _buildImageSection(),
                    const SizedBox(height: 32),

                    // Name Field
                    _buildTextField(
                      controller: _nameController,
                      label: 'Pet Name',
                      hint: 'Enter pet name',
                      icon: Icons.pets,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter pet name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Species Dropdown
                    _buildSpeciesDropdown(),
                    const SizedBox(height: 16),

                    // Breed Field (Optional)
                    _buildTextField(
                      controller: _breedController,
                      label: 'Breed (Optional)',
                      hint: 'Enter breed',
                      icon: Icons.category,
                      isRequired: false,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length < 2) {
                          return 'Breed must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Age and Weight Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _ageController,
                            label: 'Age (Optional)',
                            hint: 'Years',
                            icon: Icons.cake,
                            isRequired: false,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final age = int.tryParse(value);
                                if (age == null || age < 0) {
                                  return 'Invalid age';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _weightController,
                            label: 'Weight (Optional)',
                            hint: 'Kg',
                            icon: Icons.monitor_weight,
                            isRequired: false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final weight = double.tryParse(value);
                                if (weight == null || weight < 0) {
                                  return 'Invalid weight';
                                }
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    _buildSubmitButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),

          // Loading Overlay
          if (petState.isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: _imageFile != null
                ? ClipOval(child: Image.file(_imageFile!, fit: BoxFit.cover))
                : const Icon(Icons.pets, size: 60, color: Colors.grey),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isRequired = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeciesDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Species',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(' *', style: TextStyle(color: Colors.red, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedSpecies,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.category_outlined, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'dog', child: Text('🐕 Dog')),
            DropdownMenuItem(value: 'cat', child: Text('🐈 Cat')),
            DropdownMenuItem(value: 'bird', child: Text('🐦 Bird')),
            DropdownMenuItem(value: 'other', child: Text('🐾 Other')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedSpecies = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _handleSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      child: const Text(
        'Add Pet',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
