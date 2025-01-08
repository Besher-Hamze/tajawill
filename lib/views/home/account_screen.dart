import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final user = userController.user.value;

        if (user == null) {
          return Center(
            child: Text(
              'لا توجد بيانات حساب لعرضها.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Information Header
            Text(
              'معلومات الحساب',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16),

            // Display User Name
            ListTile(
              leading:
                  Icon(Icons.person, color: Theme.of(context).primaryColor),
              title: Text(
                'الاسم',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.name),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog(
                      context, userController, user.id, user.name, user.phone);
                },
              ),
            ),
            Divider(),

            // Display Email (non-editable)
            ListTile(
              leading: Icon(Icons.email, color: Theme.of(context).primaryColor),
              title: Text(
                'البريد الإلكتروني',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.email),
            ),
            Divider(),

            // Display Phone Number
            ListTile(
              leading: Icon(Icons.phone, color: Theme.of(context).primaryColor),
              title: Text(
                'رقم الهاتف',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.phone),
            ),
            Divider(),

            SizedBox(height: 20),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () async {
                await userController.signOut();
              },
              icon: Icon(Icons.logout),
              label: Text('تسجيل الخروج'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showEditDialog(BuildContext context, UserController userController,
      String userId, String currentName, String currentPhone) {
    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone);

    Get.defaultDialog(
      title: 'تعديل بيانات الحساب',
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'الاسم',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'رقم الهاتف',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      textConfirm: 'حفظ',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await userController.updateUserDetails(
          userId,
          nameController.text.trim(),
          phoneController.text.trim(),
        );
        Get.back();
      },
    );
  }
}
