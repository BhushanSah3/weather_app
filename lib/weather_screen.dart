import "dart:convert";
import "dart:ui";
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import "package:intl/intl.dart";

import "package:your_weather_app/additionalinfoitems.dart";
import "package:your_weather_app/hourly_forecast_items.dart";
import "package:your_weather_app/secrets.dart";

//  widget tree defines the UI structure 
//element tree which is between widget tree and render object tree
//manges  the elemnt lifecycle and  mutable state 
//render object tree willhandle layout and painting 

//build  is an elemnt helps to locate the widget ain widget tree and cpmoare the statre of the wifget and checks if neede rebuild

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();

}

class _WeatherScreenState extends State<WeatherScreen> {
  
  
  Future<Map<String, dynamic>> getCurrentWeather() async {
    // dunamic is necesasry befose the stuffs in the rhs keeps changing in api as it can be int or string but in lhs it is alwz strin g

    String cityname = "Bhubaneswar";
    try {
      final res = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openweatherapikey"),
      );
      final data = jsonDecode(
          res.body); // to check whether the connectionn is "cod": "200

      if (data["cod"] != "200") {
        throw "An unexpected error occured"; // throw returns from the function
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
    //url is the subtype of uri
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        //gesture dector doesnot give splash effct but inwell does and gesture  is good
        actions: [
          IconButton(onPressed: () {
            setState(() {
              
            });
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          // we can handle states using snapshots

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator
                    .adaptive()); // adaptive means tha tthe behinds hte block will shoe like the phone mode or os
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!; // this have a nullable option

          final currentData = data["list"][0];

          final currentTemp = currentData["main"][
              "temp"]; // this willl to show whether we are getting correct info or not

          final currentSKy = currentData["weather"][0]["main"];

          final currentpressur = currentData["main"]["pressure"];

          final currwindspeed = currentData["wind"]["speed"];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main card   have its own colour , 3d effect , maiin temp, cloud icon , weather name
                SizedBox(
                  width: double.infinity, //to make the card to its fullest
                  child: Card(
                    elevation: 10, // for the 3d effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        // to render with background
                        filter: ImageFilter.blur(
                            sigmaX: 10, sigmaY: 10), //to blur its outline
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "$currentTemp K",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Icon(
                                currentSKy == "Clouds" || currentSKy == "Rain"
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 75,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                currentSKy,
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //future weather forecast cards
                const SizedBox(height: 25),

                const Text(
                  "Future Hourly Forecast",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                //  SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [ // here in for loop all widgets will made at a asam e time

                //       for(int i=0;i<7;i++)      // no need of brackets
                //       Horlyforecastitem(
                //         time: data["list"][i+1]["dt"].toString(),

                //         icon: data["list"][i+1]["weather"][0]["main"]=="Clouds"||
                //         data["list"][i+1]["weather"][0]["main"]=="Rain"?
                //         Icons.cloud_sharp :Icons.sunny,

                //          temperature: data["list"][i+1]["main"]["temp"].toString(),
                //       ),

                //     ],
                //   ),
                // ),

                // here we are learning about lazyloading so only when we scroll the small widgets will be loading

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 30,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {

                      final hourlyForecast = data["list"][index + 1];
                      
                      final time =
                          DateTime.parse(hourlyForecast["dt_txt"].toString());
                      
                      final hourlsysky =
                          data["list"][index + 1]["weather"][0]["main"];

                      return Horlyforecastitem(
                        // the package to give dateformat in 03:00 format
                        time: DateFormat.j().format(time),

                        temperature: hourlyForecast["main"]["temp"].toString(),

                        icon: hourlsysky == "Clouds" || hourlsysky == "Rain"
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                //additional info caard

                const Text(
                  "Additional Information",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Additionalinfoitems(
                      icon: Icons.water_drop,
                      value: data["list"][0]["main"]["humidity"].toString(),
                      label: "Humidity",
                    ),
                    Additionalinfoitems(
                      icon: Icons.air,
                      value: currwindspeed.toString(),
                      label: "Wind Speed",
                    ),
                    Additionalinfoitems(
                      icon: Icons.beach_access,
                      value: "1006",
                      label: currentpressur.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

