import 'package:erebrus_app/view/home/home_controller.dart';
import 'package:get/get.dart';
import 'package:reown_appkit/reown_appkit.dart';

Future<ReownAppKitModal> reownInit(context) async {
  HomeController homeController = Get.find();

  ReownAppKitModal appKitModal = ReownAppKitModal(
    logLevel: LogLevel.error,
    context: context,
    projectId: 'b3b4f9df6bb11a074b4f4be012f1bffe',
    metadata: const PairingMetadata(
      name: 'Erebrus',
      description: 'Erebrus app description',
      url: 'https://erebrus.io/',
      icons: ['https://example.com/logo.png'],
      redirect: Redirect(
        native: 'exampleapp://',
        universal: 'https://reown.com/exampleapp',
        linkMode: true, // Choose either true or false
      ),
    ),
    featuresConfig: FeaturesConfig(
      socials: [
        AppKitSocialOption.Email,
        AppKitSocialOption.X,
        AppKitSocialOption.Google,
        AppKitSocialOption.Apple,
        AppKitSocialOption.Discord,
        AppKitSocialOption.GitHub,
        AppKitSocialOption.Facebook,
        AppKitSocialOption.Twitch,
        AppKitSocialOption.Telegram,
      ],
      showMainWallets: false,
    ),
    enableAnalytics: true,
    disconnectOnDispose: true, // Choose either true or false
  );

  await appKitModal!.init();

  appKitModal!.onModalConnect.subscribe((ModalConnect? event) async {
    if (event != null) {
      print("-------------------========    event -->> ${event.eventName}");
      print(
          "-------------------========    event 2 -->> ${event.session.connectedWalletName}");
      print(
          "-------------------========    event 3 -->> ${event.session.sessionService.name}");
      print(
          "-------------------========    event 4 -->> ${event.session.socialProvider}");
      print(
          "-------------------========    event 5 -->> ${appKitModal!.isConnected}");
      print(
          "-------------------========    event 6 -->> ${event.session.connectedWalletName}");
      if (appKitModal!.isConnected) {
        final chainId = appKitModal!.selectedChain?.chainId ?? '';
        final chain = appKitModal!.selectedChain!.currency.toLowerCase();
        final namespace = NamespaceUtils.getNamespaceFromChain(chainId);
        final address = appKitModal!.session!.getAddress(namespace);
        print("--====--->>> " + address!);
        var res = await homeController.getPASETO(
            chain: chain, walletAddress: address);
      }
    } else {
      print("-------------------========    event null");
    }
  });
  return appKitModal;
}
