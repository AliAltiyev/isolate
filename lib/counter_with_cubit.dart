import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isolate/cubit/counter_cubit.dart';

class CounterWithBlock extends StatelessWidget {
  const CounterWithBlock({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('Build method called');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<CounterCubit, CounterState>(
              builder: (context, state) {
                debugPrint('Only Text widget called');

                return Text(
                  state.counterValue.toString(),
                  style: const TextStyle(fontSize: 24),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<CounterCubit>(context).increament();
                    },
                    label: const Icon(Icons.add)),
                FloatingActionButton.extended(
                    onPressed: () {
                      if (BlocProvider.of<CounterCubit>(context)
                              .state
                              .counterValue >
                          0) {
                        BlocProvider.of<CounterCubit>(context).decreament();
                      }
                    },
                    label: const Icon(Icons.remove))
              ],
            )
          ],
        ),
      ),
    );
  }
}
