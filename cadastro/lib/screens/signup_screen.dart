import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'dart:io';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  File? _userImageFile;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Escolher Foto de Perfil'),
                  ),
                  if (_userImageFile != null) Image.file(_userImageFile!),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: _registerUser,
                    child: Text('Cadastrar'),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _registerUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      UserCredential userCredential = await _authService.signUp(
        emailController.text,
        passwordController.text,
      );
      if (_userImageFile != null) {
        String? imageUrl = await _uploadImage(_userImageFile!);
        if (imageUrl != null) {
          await userCredential.user!.updateProfile(photoURL: imageUrl);
        }
      }
      // Navegar para a próxima tela após o cadastro
      // ...
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message ?? 'Ocorreu um erro desconhecido.');
    } catch (e) {
      _showErrorDialog('Ocorreu um erro desconhecido.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _cropImage(pickedFile.path);
      }
    } catch (e) {
      _showErrorDialog('Falha ao escolher a imagem.');
    }
  }

  Future<void> _cropImage(String filePath) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Editar imagem',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Editar imagem',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
      );

      if (croppedFile != null) {
        setState(() {
          _userImageFile = File(croppedFile.path);
        });
      }
    } catch (e) {
      _showErrorDialog('Falha ao editar a imagem.');
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      String filePath = 'images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      Reference ref = FirebaseStorage.instance.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Falha ao fazer upload da imagem.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
