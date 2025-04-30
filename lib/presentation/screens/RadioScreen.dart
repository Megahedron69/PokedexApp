import 'package:flutter/material.dart';
import 'package:new_app/core/utils/TimeHelpers.dart';

class Radioscreen extends StatefulWidget {
  const Radioscreen({super.key});

  @override
  State<Radioscreen> createState() => _Radioscreen();
}

class _Radioscreen extends State<Radioscreen> {
  bool meeko = true;
  String selectedOption = '';
  bool isEngineer = false;
  String selectedScreen = 'radios';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton.filled(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.3,
                      minChildSize: 0.2,
                      maxChildSize: 0.8,
                      expand: false,
                      snap: true,
                      snapSizes: [0.2, 0.5, 0.8],
                      builder: (context, scrollController) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(blurRadius: 10, color: Colors.black26),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Handle
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              // Scrollable Content
                              Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: 30,
                                  itemBuilder:
                                      (context, index) =>
                                          ListTile(title: Text('Item $index')),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
              icon: Icon(Icons.accessibility_sharp),
            ),
            MenuAnchor(
              style: MenuStyle(
                padding: WidgetStateProperty.all(EdgeInsets.all(8.0)),
              ),
              builder:
                  (context, controller, child) => IconButton(
                    icon: const Icon(Icons.ad_units),
                    onPressed: () {
                      controller.open();
                    },
                  ),
              menuChildren: [
                MenuItemButton(onPressed: () {}, child: const Text('Item 1')),
                MenuItemButton(onPressed: () {}, child: const Text('Item 2')),
                Row(
                  children: [
                    Text("Swittch:"),
                    Switch(
                      value: true,
                      onChanged: (value) {
                        setState(() {
                          value = false;
                          print("pp:$value");
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),

            IconButton.filledTonal(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('AlertDialog Title'),
                      content: const SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('This is a demo alert dialog.'),
                            Text('Would you like to approve of this message?'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Approve'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.zoom_in_map_outlined),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3.0)),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ),
            ListTile(
              title: const Text("Radios"),
              onTap: () {
                setState(() {
                  selectedScreen = "radios";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Inputs'),
              onTap: () {
                setState(() {
                  selectedScreen = "inputs";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('dropdowns'),
              onTap: () {
                setState(() {
                  selectedScreen = "dropdowns";
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Item 5'),
              onTap: () {
                setState(() {
                  selectedScreen = "radios";
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: Scaffold.of(context).openDrawer,
                    icon: const Icon(Icons.menu),
                  );
                },
              ),
              Builder(
                builder: (context) {
                  switch (selectedScreen) {
                    case 'radios':
                      return Radios(
                        isEngineer: isEngineer,
                        selectedOption: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value;
                          });
                        },
                      );
                    case 'inputs':
                      return inputScreen();
                    default:
                      return Placeholder();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Radios extends StatefulWidget {
  final bool isEngineer;
  final String selectedOption;
  final void Function(String) onChanged;

  const Radios({
    super.key,
    required this.isEngineer,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  State<Radios> createState() => _RadiosState();
}

class _RadiosState extends State<Radios> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selectedOption;
  }

  void updateSelection(String? value) {
    setState(() {
      selected = value ?? '';
    });
    widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Are you okay with this?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 20),
            Radio(
              value: 'Yes',
              groupValue: selected,

              onChanged: updateSelection,
            ),
            const Text('Yes'),
            Radio(
              value: 'No',
              groupValue: selected,

              onChanged: updateSelection,
            ),
            const Text('No'),
          ],
        ),
        if (!widget.isEngineer)
          Row(
            children: [
              const Text(
                "Are you okay with this?",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 20),
              Radio.adaptive(
                value: 'Yes',
                groupValue: selected,
                useCupertinoCheckmarkStyle: true,
                onChanged: updateSelection,
              ),
              const Text('Yes'),
              Radio.adaptive(
                value: 'No',
                groupValue: selected,
                useCupertinoCheckmarkStyle: true,
                onChanged: updateSelection,
              ),
              const Text('No'),
            ],
          ),
        RadioListTile<String>(
          title: const Text('Yes'),
          subtitle: const Text('okke'),
          dense: true,
          toggleable: true,
          value: 'Yes',
          groupValue: selected,
          onChanged: updateSelection,
        ),
        RadioListTile<String>(
          title: const Text('No'),
          toggleable: true,
          value: 'No',
          groupValue: selected,
          onChanged: updateSelection,
        ),
        const SizedBox(height: 30),
        Text(
          'You selected: $selected',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class inputScreen extends StatefulWidget {
  State<inputScreen> createState() => _inputScreenPlan();
}

class _inputScreenPlan extends State<inputScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime now;
  late Map<String, dynamic> formData;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  @override
  void initState() {
    now = DateTime.now();
    formData = {
      "email": "",
      "password": "",
      "age": 12,
      "date": getFormattedDate(now),
      "time": getFormattedTime(TimeOfDay.now()),
      "mobile": 8826237744,
      "code": "+91",
      "remarks": "",
    };
    _dateController = TextEditingController(text: formData["date"]);
    _timeController = TextEditingController(text: formData["time"]);
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void handleChange(String key, dynamic value) {
    if (!mounted) return;
    setState(() {
      formData[key] = value;
    });
  }

  void clearForm() {
    setState(() {
      _dateController.clear();
      _timeController.clear();
      formData = {
        "email": "",
        "password": "",
        "age": 12,
        "date": getFormattedDate(now),
        "time": getFormattedTime(TimeOfDay.now()),
        "mobile": 8826237744,
        "code": "+91",
        "remarks": "",
      };
      _formKey.currentState?.reset();
    });
  }

  String? validateField(String key, dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'This field is required';
    }

    switch (key) {
      case 'email':
        final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Invalid email address';
        }
        break;

      case 'password':
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        break;

      case 'age':
        final age = int.tryParse(value.toString());
        if (age == null || age < 12 || age > 120) {
          return 'Enter a valid age (12-120)';
        }
        break;

      case 'date':
        // You might want to validate date format like 'dd-mm-yyyy'
        final dateRegex = RegExp(r'^\d{2}/\d{2}/\d{2}$');
        if (!dateRegex.hasMatch(value)) {
          return 'Enter a valid date (dd/MM/yy)';
        }
        break;

      case 'time':
        // Validate time format like 'HH:mm'
        final timeRegex = RegExp(
          r'^(0?[1-9]|1[0-2]):[0-5][0-9]\s?(AM|PM)$',
          caseSensitive: false,
        );
        if (!timeRegex.hasMatch(value)) {
          return 'Enter a valid time (e.g. 09:30 AM)';
        }
        break;

      case 'mobile':
        final mobileStr = value.toString();
        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(mobileStr)) {
          return 'Enter a valid 10-digit mobile number';
        }
        break;

      case 'code':
        if (!RegExp(r'^\+\d{1,3}$').hasMatch(value)) {
          return 'Enter a valid country code like +91';
        }
        break;

      case 'remarks':
        if (value.length > 250) {
          return 'Remarks should not exceed 250 characters';
        }
        break;

      default:
        return null;
    }

    return null;
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2021),
      lastDate: DateTime(2027),
    );
    if (pickedDate != null) {
      String formattedDate = getFormattedDate(pickedDate);
      handleChange("date", formattedDate);
      _dateController.text = formattedDate;
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      String formattedTime = getFormattedTime(pickedTime);
      handleChange("time", formattedTime);
      _timeController.text = formattedTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(9.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) => handleChange("email", value),
                      validator: (value) => validateField("email", value),
                      autofillHints: [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 12,
                        ),
                        suffixIcon: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          child: Icon(Icons.email, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12.0,
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "age",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => validateField("age", value),
                      items:
                          List.generate(46, (index) => index + 15)
                              .map(
                                (num) => DropdownMenuItem(
                                  value: num,
                                  child: Text(num.toString()),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => handleChange("age", value),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      // validator: (value) => validateField("date", value),
                      decoration: InputDecoration(
                        labelText: "Date",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_month),
                          onPressed: () async => await _selectDate(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _timeController,
                      validator: (value) => validateField("time", value),
                      decoration: InputDecoration(
                        labelText: "Time",
                        suffixIcon: IconButton(
                          onPressed: () => _selectTime(),
                          icon: Icon(Icons.watch_later),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12.0,
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      autofillHints: [AutofillHints.telephoneNumber],
                      validator: (value) => validateField("mobile", value),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => handleChange("mobile", value),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Mobile",
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField(
                      items:
                          List.generate(3, (index) => index)
                              .map(
                                (num) => DropdownMenuItem(
                                  value: "+9$num",
                                  child: Text("+9$num"),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => handleChange("code", value),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Code",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Expanded(
                    child: TextFormField(
                      minLines: 3,
                      maxLines: 5,
                      onChanged: (value) => handleChange("remarks", value),
                      decoration: InputDecoration(
                        labelText: "Remarks",
                        hintText: "Enter your remarks",
                        counterText: "300 words",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12.0,
                children: [
                  Expanded(
                    child: TextFormField(
                      obscureText: true,
                      autofillHints: [AutofillHints.password],
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => validateField("password", value),
                      onChanged: (value) => handleChange("age", value),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => clearForm(),
                      child: Text("Clear"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => print("Submittng"),
                      child: Text("Submit"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
