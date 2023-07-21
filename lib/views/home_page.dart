import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:pal/pallete.dart';
import 'package:pal/services/openai_services.dart';
import 'package:pal/widgets/feature_box.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late FlutterGifController controller;

  TextEditingController userInputTextEditingController =
      TextEditingController();
  final SpeechToText speechToText = SpeechToText();
  String textSpeech = "";
  final OpenAiService openAiService = OpenAiService();
  FlutterTts flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImgUrl;

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  void initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    FocusScope.of(context).unfocus();
    await speechToText.listen(
        onResult: onSpeechToTextResult, pauseFor: const Duration(seconds: 5));
    setState(() {});
  }

  Future<void> stopListening() async {
    FocusScope.of(context).unfocus();
    await speechToText.stop();
  }

  void onSpeechToTextResult(SpeechRecognitionResult result) {
    setState(() {
      textSpeech = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void initState() {
    controller = FlutterGifController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true, min: 0, max: 1);
    initSpeechToText();
    initTextToSpeech();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    speechToText.stop();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: ZoomIn(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: FloatingActionButton(
              onPressed: () async {
                if (await speechToText.hasPermission &&
                    speechToText.isNotListening) {
                  await startListening();
                } else if (speechToText.isListening) {
                  final speech = await openAiService.isArtPromptApi(textSpeech);
                  if (speech.contains("https")) {
                    generatedImgUrl = speech;
                    generatedContent = null;
                    setState(() {});
                  } else {
                    generatedImgUrl = null;
                    generatedContent = speech;
                    setState(() {});
                    await systemSpeak(speech);
                  }
                  await stopListening();
                } else {
                  initSpeechToText();
                }
              },
              backgroundColor: speechToText.isListening
                  ? Colors.lightGreenAccent
                  : Pallete.firstSuggestionBoxColor,
              child: speechToText.isListening
                  ? const Icon(Icons.stop)
                  : const Icon(Icons.mic_rounded),
            ),
          ),
        ),
        appBar: AppBar(
          title: BounceInDown(
            child: const Text("Pal"),
          ),
          centerTitle: true,
          // leading: const Icon(Icons.menu_rounded),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //virtual assistant pic
              ZoomIn(
                child: GifImage(
                  image: const AssetImage("assets/images/icons8-robot.gif"),
                  controller: controller,
                ),
              ),

              //chat bubble
              FadeInRight(
                child: Visibility(
                  visible: generatedImgUrl == null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 40)
                        .copyWith(top: 30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor),
                      borderRadius: BorderRadius.circular(20).copyWith(
                        topLeft: Radius.zero,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        generatedContent == null
                            ? "Hello! how can i be of service?"
                            : generatedContent!,
                        style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontSize: generatedContent == null ? 25 : 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (generatedImgUrl != null)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                    child: Image.network(
                      generatedImgUrl!,
                    ),
                  ),
                ),
              SlideInLeft(
                child: Visibility(
                  visible: generatedContent == null && generatedImgUrl == null,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 10, left: 22),
                    child: const Text(
                      "Here are a few feature",
                      style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              //features list
              Visibility(
                visible: generatedContent == null && generatedImgUrl == null,
                child: Column(
                  children: [
                    FadeInLeft(
                      delay: const Duration(milliseconds: 200),
                      child: const FeatureBox(
                        color: Pallete.firstSuggestionBoxColor,
                        headerTxt: "ChatGPT",
                        descriptionTxt:
                            "A smarter way to stay organized and informed with ChatGPT",
                      ),
                    ),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 400),
                      child: const FeatureBox(
                        color: Pallete.secondSuggestionBoxColor,
                        headerTxt: "DALL-E",
                        descriptionTxt:
                            "Get inspired and stay creative with your personal assistant powered by DALL-E",
                      ),
                    ),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 600),
                      child: const FeatureBox(
                        color: Pallete.thirdSuggestionBoxColor,
                        headerTxt: "Smart Voice Assistant",
                        descriptionTxt:
                            "Get the best of both worlds with a voice assistant powered by ChatGPT and DALL-E",
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   child: Text(
              //     textSpeech,
              //     textAlign: TextAlign.center,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
