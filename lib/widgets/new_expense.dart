import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({Key? key}) : super(key: key);

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              prefixText: '\$',
              labelText: 'Amount'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            ElevatedButton(onPressed: (){}, child: Text('Close')),
            const SizedBox(width: 16),
            ElevatedButton(onPressed:(){
              print(_titleController.text);
            } , child: const Text('Save Expense')),
          ],
        )
      ]),
    );
  }
}
