import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web3_example/owner/cubit/owner_cubit.dart';

class AddProposalsWidget extends StatelessWidget {
  const AddProposalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Builder(
      builder: (context) {
        return BlocBuilder<OwnerCubit, OwnerState>(
          builder: (context, state) {
            OwnerCubit cubit = OwnerCubit.get(context);
            return Container(
              width: size.width * .4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * .04,
                  vertical: size.height * .05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add Proposals",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        letterSpacing: 2,
                        height: 1.3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ListView.separated(
                      itemCount: OwnerCubit.listFiled.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _buildTextField(
                          cubit,
                          index,
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: MaterialButton(
                              onPressed: cubit.isMining || cubit.isSetProposals
                                  ? null
                                  : () {
                                      cubit.addProposals(context);
                                    },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 20),
                                  child: cubit.isSetProposals
                                      ? const CircularProgressIndicator(
                                          color: Color(0xff6E36B6),
                                        )
                                      : Text(
                                          cubit.isMining
                                              ? "Mining ..."
                                              : "Save",
                                          style: GoogleFonts.chakraPetch(
                                            textStyle: const TextStyle(
                                              color: Color(0xff6E36B6),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (cubit.message.isNotEmpty) const SizedBox(height: 10),
                    if (cubit.message.isNotEmpty)
                      Text(
                        "Error: ${cubit.message}",
                        style: GoogleFonts.chakraPetch(
                          textStyle: TextStyle(
                            color: Colors.redAccent.withOpacity(0.7),
                            fontSize: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(OwnerCubit cubit, int index) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: OwnerCubit.listFiled[index],
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: const Color(0xff808080).withOpacity(0.7),
                    width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: const Color(0xff808080).withOpacity(0.4),
                    width: 1.5),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffe61f34), width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            onPressed: () {
              cubit.addField(index);
            },
            icon: (index == OwnerCubit.listFiled.length - 1)
                ? const Icon(
                    Icons.add,
                    color: Color(0xff2F2D6D),
                  )
                : const Icon(
                    Icons.remove,
                    color: Color(0xff8A3277),
                  ),
          ),
        )
      ],
    );
  }
}
