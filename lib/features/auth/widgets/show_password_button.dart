import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_bloc.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_event.dart';
import 'package:surf_practice_chat_flutter/bloc/auth/auth_state.dart';

class ShowPasswordButton extends StatefulWidget {
  const ShowPasswordButton({Key? key}) : super(key: key);

  @override
  State<ShowPasswordButton> createState() => _ShowPasswordButtonState();
}

class _ShowPasswordButtonState extends State<ShowPasswordButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _lineController;
  late final Animation<double> _lineAnimation;

  @override
  void initState() {
    _lineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _lineAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _lineController,
      curve: Curves.decelerate,
    ));
    final authState = context.read<AuthBloc>().state;
    if (authState is NotAuthorizedState &&
        authState.showPassword &&
        _lineController.status == AnimationStatus.completed) {
      _lineController.animateBack(0);
    }
    super.initState();
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) {
        if (previous is NotAuthorizedState && current is NotAuthorizedState) {
          return previous.showPassword != current.showPassword ||
              previous.passwordTextInput.isEmpty !=
                  current.passwordTextInput.isEmpty;
        }
        return previous.runtimeType != current.runtimeType;
      },
      builder: (context, authState) {
        if (authState.runtimeType != NotAuthorizedState) {
          return Container();
        }
        authState as NotAuthorizedState;
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: authState.passwordTextInput.isNotEmpty ? 1.0 : 0.0,
          child: Material(
            borderRadius: BorderRadius.circular(50.0),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(50.0),
              onTap: () {
                authBloc.add(TogglePasswordDisplayEvent());
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/eye.svg',
                      color: Colors.grey,
                    ),
                    Transform.rotate(
                      angle: .5,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        width: authState.showPassword ? 24.0 : 0.0,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
