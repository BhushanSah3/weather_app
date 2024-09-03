import "package:flutter/material.dart";

class Horlyforecastitem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const Horlyforecastitem({
    super.key,
    required this.time,
    required this.icon,
    required this.temperature,

  });

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      width: 110,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child:   Padding(
          padding:const EdgeInsets.all(5.0),
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                 maxLines: 1, // for the text if it overflows
                 overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),
                  Icon(
                    icon,
                    size: 32,
                  ),
                const   SizedBox(height: 6),
                  Text(
                    temperature,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
