// import 'dart:typed_data';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:naya_menu/service/firebase/firebase_storage_service.dart';
import 'package:universal_io/io.dart' as uio;
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/old/category.dart';
import '../widgets/progress_indicator.dart';
import '../../models/old/meal.dart';
import '../../service/firebase/old/firestore_category_service.dart';
import '../../service/firebase/old/firestore_meal_service.dart';
import '../widgets/input_fields.dart';
import '../image/old/image_upload_popup.dart';

class MealCreatePage extends StatefulWidget {
  final String restaurantId;

  const MealCreatePage({
    required this.restaurantId,
  });

  @override
  _MealCreatePageState createState() => _MealCreatePageState();
}

class _MealCreatePageState extends State<MealCreatePage> {
  uio.File? _imageFile;
  Uint8List? _imageBytes;
  String? _downloadUrl;
  bool _isUploading = false;

  final FirebaseStorageService _firebaseStorageService =
      FirebaseStorageService();

  final FirestoreMealService _firestoreMealService = FirestoreMealService();

  final FirestoreCategoryService _firestoreCategoryService =
      FirestoreCategoryService();

  final TextEditingController _mealTitleController = TextEditingController();
  final TextEditingController _mealDescriptionController =
      TextEditingController();
  final TextEditingController _mealPriceController = TextEditingController();
  final TextEditingController _mealIngredientsController =
      TextEditingController();

  MealSize? _selectedSize;
  bool _hasAdditions = false;
  Currency _selectedCurrency = Currency.USD;
  Category? _selectedCategory;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    // _loadCategories();
  }

  // Future<void> _loadCategories() async {
  //   try {
  //     List<Category> categories =
  //         await _firestoreCategoryService.getCategories(widget.restaurantId);
  //     setState(() {
  //       _categories = categories;
  //     });
  //   } catch (e) {
  //     print('Error loading categories: $e');
  //   }
  // }

  void _openImageUploadPopup() {
    showDialog(
      context: context,
      builder: (context) => ImageUploadPopup(
        onImageUploaded: (String? downloadUrl) {
          setState(() {
            if (downloadUrl != null) {
              _downloadUrl = downloadUrl;
            }
          });
        },
      ),
    );
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null && _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    if (_mealTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a meal title first.')),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category first.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      String title = _mealTitleController.text;
      String downloadUrl;
      if (_imageFile != null) {
        // downloadUrl = await _firebaseStorageService.uploadImage(_imageFile!,
        //     widget.restaurantId, title, 'meals/${_selectedCategory!.id}');
      } else {
        // downloadUrl = await _firebaseStorageService.uploadImage(
        //     _imageBytes!,
        //     widget.restaurantId,
        //     title,
        //     'meals/${_selectedCategory!.id}');
      }
      setState(() {
        // _downloadUrl = downloadUrl;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image uploaded successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _saveMeal() async {
    if (_mealTitleController.text.isEmpty ||
        _downloadUrl == null ||
        _mealPriceController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Please fill in all fields, select a category, and upload an image.')),
      );
      return;
    }

    int mealCounter = await _firestoreMealService.getNextMealCounter(
        widget.restaurantId, _selectedCategory!.id);
    String mealId = '${_selectedCategory!.id}_M$mealCounter';
    double price = double.parse(_mealPriceController.text);

    Meal meal = Meal(
      id: mealId,
      title: _mealTitleController.text,
      description: _mealDescriptionController.text,
      imageUrl: _downloadUrl!,
      price: price,
      currency: _selectedCurrency,
      categories: [_selectedCategory!.id],
      ingredients: _mealIngredientsController.text.isEmpty
          ? null
          : _mealIngredientsController.text.split(','),
      size: _selectedSize,
      hasAdditions: _hasAdditions,
      isAvailable: true, // Default value for availability
    );

    try {
      await _firestoreMealService.addMeal(
          meal, widget.restaurantId, _selectedCategory!.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meal saved successfully.')),
      );
      // Reset form
      _mealTitleController.clear();
      _mealDescriptionController.clear();
      _mealPriceController.clear();
      _mealIngredientsController.clear();
      setState(() {
        _imageFile = null;
        _imageBytes = null;
        _downloadUrl = null;
        _selectedSize = null;
        _hasAdditions = false;
        _selectedCurrency = Currency.USD;
        _selectedCategory = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving meal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser;

    // if (user == null) {
    //   return Scaffold(
    //     appBar: AppBar(title: Text('Create Meal')),
    //     body: Center(
    //       child: Text('You are not signed in.'),
    //     ),
    //   );
    // }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: GestureDetector(
                      onTap: _openImageUploadPopup,
                      child: _imageFile != null
                          ? Image.file(_imageFile!,
                              height: 200, fit: BoxFit.cover)
                          : _imageBytes != null
                              ? Image.memory(_imageBytes!,
                                  height: 200, fit: BoxFit.cover)
                              : Center(child: Text('Tap to select image')),
                    ),
                  ),
                  SizedBox(height: 20),
                  _isUploading
                      ? CustomProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: _uploadImage,
                          icon: Icon(Icons.upload_file),
                          label: Text('Upload Image'),
                        ),
                  const SizedBox(height: 20),
                  InputField(
                    label: 'Meal Title',
                    hintText: 'Enter meal name',
                    controller: _mealTitleController,
                    textCapitalization: TextCapitalization.words,
                    labelAboveField: true,
                  ),
                  SizedBox(height: 20),
                  InputField(
                    label: 'Meal Description (optional)',
                    hintText: 'Enter meal description',
                    controller: _mealDescriptionController,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _mealPriceController,
                    decoration: InputDecoration(
                      labelText: 'Meal Price',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _mealIngredientsController,
                    decoration: InputDecoration(
                      labelText: 'Ingredients (comma separated, optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.list),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<MealSize>(
                    items: MealSize.values.map((MealSize size) {
                      return DropdownMenuItem<MealSize>(
                        value: size,
                        child: Text(size.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSize = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Size (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<Currency>(
                    value: _selectedCurrency,
                    items: Currency.values.map((Currency currency) {
                      return DropdownMenuItem<Currency>(
                        value: currency,
                        child: Text(currency.toString().split('.').last),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCurrency = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Currency',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<Category>(
                    items: _categories.map((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.title),
                      );
                    }).toList(),
                    onChanged: (selectedCategory) {
                      setState(() {
                        _selectedCategory = selectedCategory;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Category',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  CheckboxListTile(
                    title: Text('Has Additions (e.g., fries, drink)'),
                    value: _hasAdditions,
                    onChanged: (newValue) {
                      setState(() {
                        _hasAdditions = newValue ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveMeal,
                    child: Text('Save Meal'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
