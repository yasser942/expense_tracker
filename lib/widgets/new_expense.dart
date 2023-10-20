import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({Key? key, required this.onAddExpense}) : super(key: key);
  final Function onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.work;

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final isInvalidAmount = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        isInvalidAmount ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid Input'),
              content: const Text('Please fill all the fields'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Okay'))
              ],
            );
          });
      return;
    }
    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    prefixText: '\$', labelText: 'Amount'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: _presentDatePicker,
                key: const ValueKey('date_picker'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null
                        ? 'No Date Chosen'
                        : formatter.format(_selectedDate!)),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map((item) => DropdownMenuItem(
                        value: item, child: Text(item.name.toUpperCase())))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    if (value == null) {
                      return;
                    } else {
                      _selectedCategory = value;
                    }
                  });
                }),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close')),
            const SizedBox(width: 16),
            ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save Expense')),
          ],
        )
      ]),
    );
  }
}
