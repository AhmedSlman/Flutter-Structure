import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//import '../../../home/presentation/screens/home_screen.dart';
import '../../cubit/layout_cubit.dart';
import '../../cubit/layout_states.dart';
import '../widgets/widgets.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.index});
  final int? index;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LayoutCubit()..initTabBar(this, widget.index ?? 0),
      child: BlocConsumer<LayoutCubit, LayoutStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = LayoutCubit.get(context);
          return Scaffold(
            body: TabBarView(
              controller: cubit.tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                //    const HomeScreen(),
                Container(color: Colors.blue),
                Container(color: Colors.red),
                Container(),
                Container(),
              ],
            ),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: cubit.tabController.index,
              onTap: cubit.changeTab,
            ),
            extendBody: true,
          );
        },
      ),
    );
  }
}
