import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/crop_model.dart';
import '../../data/models/advisory_model.dart';
import '../controllers/advisory_controller.dart';
import '../controllers/crop_controller.dart';
import '../../../profile/profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../l10n/app_localizations.dart';

class AdvisoryScreen extends StatelessWidget {
  const AdvisoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdvisoryController(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).fertilizerAdvisory,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Consumer<AdvisoryController>(
          builder: (context, advisoryController, child) {
            // Note: AdvisoryController no longer manages crop state directly,
            // so we don't check for its loading here for the initial screen.
            // CropController handles the initial crop list loading.

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeatherHeader(context, advisoryController),
                  const SizedBox(height: 24),
                  _buildSectionTitle(AppLocalizations.of(context).selectCrop),
                  const SizedBox(height: 12),
                  _buildCropSelector(context, advisoryController),
                  const SizedBox(height: 12),
                  _buildSelectedCropDisplay(),
                  const SizedBox(height: 24),

                  // Consume CropController to check for selection
                  Consumer<CropController>(
                    builder: (context, cropController, _) {
                      if (cropController.selectedCrop != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildGrowthStageSelector(
                              context,
                              advisoryController,
                              cropController.selectedCrop!,
                            ),
                            const SizedBox(height: 24),
                            _buildFieldSizeSlider(context, advisoryController),
                            const SizedBox(height: 24),
                            _buildSoilHealthSection(
                              context,
                              advisoryController,
                            ),
                            const SizedBox(height: 24),
                            _buildCropIssuesSection(
                              context,
                              advisoryController,
                            ),
                            const SizedBox(height: 32),
                            _buildCalculateButton(
                              context,
                              advisoryController,
                              cropController,
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                              AppLocalizations.of(
                                context,
                              ).pleaseSelectACropAbove,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  if (advisoryController.isCalculating)
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (advisoryController.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        advisoryController.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (advisoryController.advisoryResult != null &&
                      !advisoryController.isCalculating)
                    _buildResultSection(
                      context,
                      advisoryController.advisoryResult!,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildWeatherHeader(
    BuildContext context,
    AdvisoryController controller,
  ) {
    final weather = controller.currentWeather;
    if (weather == null) return const SizedBox(); // Or a shimmer placeholder

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).currentWeather,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
              ),
              const SizedBox(height: 4),
              Text(
                "${weather.temperature.toStringAsFixed(1)}°C",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                weather.condition,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _weatherInfoRow(Icons.water_drop, "${weather.humidity}%"),
              const SizedBox(height: 4),
              _weatherInfoRow(Icons.air, "${weather.windSpeed} m/s"),
              if (weather.rainProbability > 0) ...[
                const SizedBox(height: 4),
                _weatherInfoRow(
                  Icons.umbrella,
                  AppLocalizations.of(context).rainProbabilityAmount(
                    (weather.rainProbability * 100).toInt().toString(),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _weatherInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildCropSelector(
    BuildContext context,
    AdvisoryController advisoryController,
  ) {
    return Consumer<CropController>(
      builder: (context, cropController, child) {
        if (cropController.isLoading) {
          return SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (_, _) => _buildShimmerCrop(),
            ),
          );
        }

        if (cropController.errorMessage.isNotEmpty) {
          return SizedBox(
            height: 100,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).failedToLoadCrops,
                    style: TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () => cropController.retry(),
                    child: Text(AppLocalizations.of(context).retry),
                  ),
                ],
              ),
            ),
          );
        }

        final crops = cropController.crops;
        final allCrops = cropController.allCrops;
        final hasMoreCrops =
            allCrops.length > CropController.INITIAL_CROPS_LIMIT;
        final showViewAllButton = hasMoreCrops && !cropController.showAllCrops;

        return SizedBox(
          height: 140, // Height for avatar + text
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: crops.length + (showViewAllButton ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              if (showViewAllButton && index == crops.length) {
                // Show "View All" button only after 10 crops
                return GestureDetector(
                  onTap: () {
                    _showAllCropsModal(context, advisoryController);
                  },
                  child: _buildViewAllCard(context),
                );
              }
              final crop = crops[index];
              final isSelected = cropController.selectedCrop?.id == crop.id;

              return GestureDetector(
                onTap: () {
                  cropController.selectCrop(crop);
                  // Reset growth stage in advisory controller when crop changes
                  if (crop.growthStages.isNotEmpty) {
                    advisoryController.setGrowthStage(crop.growthStages[0]);
                  }
                },
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: crop.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      child: Text(
                        _getLocalizedCropName(context, crop.name),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.green[800]
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _getLocalizedCropName(BuildContext context, String name) {
    final l10n = AppLocalizations.of(context);
    switch (name) {
      case 'Paddy (Rice)':
        return l10n.cropPaddyRice;
      case 'Wheat':
        return l10n.cropWheat;
      case 'Jowar (Sorghum)':
        return l10n.cropJowarSorghum;
      case 'Bajra (Pearl Millet)':
        return l10n.cropBajraPearlMillet;
      case 'Maize (Corn)':
        return l10n.cropMaizeCorn;
      case 'Ragi (Finger Millet)':
        return l10n.cropRagiFingerMillet;
      case 'Barley':
        return l10n.cropBarley;
      case 'Oats':
        return l10n.cropOats;
      case 'Tur (Pigeon Pea)':
        return l10n.cropTurPigeonPea;
      case 'Moong (Green Gram)':
        return l10n.cropMoongGreenGram;
      case 'Urad (Black Gram)':
        return l10n.cropUradBlackGram;
      case 'Chickpea (Gram)':
        return l10n.cropChickpeaGram;
      case 'Masoor (Red Lentil)':
        return l10n.cropMasoorRedLentil;
      case 'Cowpea (Lobia)':
        return l10n.cropCowpeaLobia;
      case 'Horse Gram (Kulthi)':
        return l10n.cropHorseGramKulthi;
      case 'Soybean':
        return l10n.cropSoybean;
      case 'Groundnut (Peanut)':
        return l10n.cropGroundnutPeanut;
      case 'Sunflower':
        return l10n.cropSunflower;
      case 'Mustard (Rapeseed)':
        return l10n.cropMustardRapeseed;
      case 'Sesame (Til)':
        return l10n.cropSesameTil;
      case 'Linseed (Flax)':
        return l10n.cropLinseedFlax;
      case 'Castor':
        return l10n.cropCastor;
      case 'Safflower':
        return l10n.cropSafflower;
      case 'Cotton':
        return l10n.cropCotton;
      case 'Sugarcane':
        return l10n.cropSugarcane;
      case 'Jute':
        return l10n.cropJute;
      case 'Tobacco':
        return l10n.cropTobacco;
      case 'Tomato':
        return l10n.cropTomato;
      case 'Onion':
        return l10n.cropOnion;
      case 'Potato':
        return l10n.cropPotato;
      case 'Brinjal (Eggplant)':
        return l10n.cropBrinjalEggplant;
      case 'Okra (Bhindi)':
        return l10n.cropOkraBhindi;
      case 'Chili (Hot Pepper)':
        return l10n.cropChiliHotPepper;
      case 'Capsicum (Bell Pepper)':
        return l10n.cropCapsicumBellPepper;
      case 'Cauliflower':
        return l10n.cropCauliflower;
      case 'Cabbage':
        return l10n.cropCabbage;
      case 'Cucumber':
        return l10n.cropCucumber;
      case 'Bitter Gourd (Karela)':
        return l10n.cropBitterGourdKarela;
      case 'Bottle Gourd (Lauki)':
        return l10n.cropBottleGourdLauki;
      case 'Pumpkin':
        return l10n.cropPumpkin;
      case 'Watermelon':
        return l10n.cropWatermelon;
      case 'Muskmelon (Kharbooj)':
        return l10n.cropMuskmelonKharbooj;
      case 'Garlic':
        return l10n.cropGarlic;
      case 'Spinach (Palak)':
        return l10n.cropSpinachPalak;
      case 'Fenugreek (Methi)':
        return l10n.cropFenugreekMethi;
      case 'Carrot':
        return l10n.cropCarrot;
      case 'Radish (Mooli)':
        return l10n.cropRadishMooli;
      case 'Mango':
        return l10n.cropMango;
      case 'Banana':
        return l10n.cropBanana;
      case 'Grapes':
        return l10n.cropGrapes;
      case 'Pomegranate':
        return l10n.cropPomegranate;
      case 'Orange (Nagpur)':
        return l10n.cropOrangeNagpur;
      case 'Papaya':
        return l10n.cropPapaya;
      case 'Guava':
        return l10n.cropGuava;
      case 'Coconut':
        return l10n.cropCoconut;
      case 'Custard Apple (Sitaphal)':
        return l10n.cropCustardAppleSitaphal;
      case 'Lemon':
        return l10n.cropLemon;
      case 'Strawberry':
        return l10n.cropStrawberry;
      case 'Fig (Anjeer)':
        return l10n.cropFigAnjeer;
      case 'Sweet Lime (Mosambi)':
        return l10n.cropSweetLimeMosambi;
      case 'Jackfruit':
        return l10n.cropJackfruit;
      case 'Sapodilla (Chiku)':
        return l10n.cropSapodillaChiku;
      case 'Turmeric (Haldi)':
        return l10n.cropTurmericHaldi;
      case 'Ginger (Adrak)':
        return l10n.cropGingerAdrak;
      case 'Coriander (Dhaniya)':
        return l10n.cropCorianderDhaniya;
      case 'Cumin (Jeera)':
        return l10n.cropCuminJeera;
      case 'Fennel (Saunf)':
        return l10n.cropFennelSaunf;
      case 'Cardamom (Elaichi)':
        return l10n.cropCardamomElaichi;
      case 'Pepper (Kali Mirch)':
        return l10n.cropPepperKaliMirch;
      case 'Tea':
        return l10n.cropTea;
      case 'Coffee':
        return l10n.cropCoffee;
      case 'Rubber':
        return l10n.cropRubber;
      case 'Sweet Potato':
        return l10n.cropSweetPotato;
      case 'Tapioca (Cassava)':
        return l10n.cropTapiocaCassava;
      case 'Colocasia (Arbi)':
        return l10n.cropColocasiaArbi;
      case 'Lucerne (Alfalfa)':
        return l10n.cropLucerneAlfalfa;
      case 'Berseem Clover':
        return l10n.cropBerseemClover;
      case 'Napier Grass':
        return l10n.cropNapierGrass;
      case 'Marigold':
        return l10n.cropMarigold;
      case 'Rose':
        return l10n.cropRose;
      case 'Jasmine (Mogra)':
        return l10n.cropJasmineMogra;
      case 'Chrysanthemum':
        return l10n.cropChrysanthemum;
      case 'Tuberose (Rajnigandha)':
        return l10n.cropTuberoseRajnigandha;
      case 'French Beans':
        return l10n.cropFrenchBeans;
      case 'Peas (Matar)':
        return l10n.cropPeasMatar;
      case 'Beetroot':
        return l10n.cropBeetroot;
      case 'Turnip (Shalgam)':
        return l10n.cropTurnipShalgam;
      case 'Drumstick (Moringa)':
        return l10n.cropDrumstickMoringa;
      case 'Snake Gourd':
        return l10n.cropSnakeGourd;
      case 'Sponge Gourd (Turai)':
        return l10n.cropSpongeGourdTurai;
      case 'Ridge Gourd (Torai)':
        return l10n.cropRidgeGourdTorai;
      case 'Lettuce':
        return l10n.cropLettuce;
      case 'Sweet Corn':
        return l10n.cropSweetCorn;
      case 'Apple':
        return l10n.cropApple;
      case 'Pineapple':
        return l10n.cropPineapple;
      case 'Avocado':
        return l10n.cropAvocado;
      case 'Aloe Vera':
        return l10n.cropAloeVera;
      case 'Stevia':
        return l10n.cropStevia;
      case 'Ashwagandha':
        return l10n.cropAshwagandha;
      default:
        return name;
    }
  }

  String _getLocalizedGrowthStage(BuildContext context, String stage) {
    final l10n = AppLocalizations.of(context);
    switch (stage) {
      case 'Seedling':
        return l10n.seedling;
      case 'Vegetative':
        return l10n.vegetative;
      case 'Flowering':
        return l10n.flowering;
      case 'Fruiting':
        return l10n.fruiting;
      case 'Maturity':
        return l10n.maturity;
      case 'Transplanting':
        return l10n.transplanting;
      case 'Tillering':
        return l10n.tillering;
      case 'Panicle Initiation':
        return l10n.panicleInitiation;
      case 'Panicle Emergence':
        return l10n.panicleEmergence;
      case 'Jointing':
        return l10n.jointing;
      case 'Booting':
        return l10n.booting;
      case 'Grain Fill':
        return l10n.grainFill;
      case 'Knee High':
        return l10n.kneeHigh;
      case 'Tasseling':
        return l10n.tasseling;
      case 'Silking':
        return l10n.silking;
      case 'Dough':
        return l10n.dough;
      case 'Pod Development':
        return l10n.podDevelopment;
      case 'Germination':
        return l10n.germination;
      case 'Bud Differentiation':
        return l10n.budDifferentiation;
      case 'Fruit Set':
        return l10n.fruitSet;
      case 'Fruit Development':
        return l10n.fruitDevelopment;
      case 'Flower Bud':
        return l10n.flowerBud;
      case 'Juvenile':
        return l10n.juvenile;
      case 'Bearing':
        return l10n.bearing;
      case 'Full Production':
        return l10n.fullProduction;
      case 'Shoot Emergence':
        return l10n.shootEmergence;
      case 'Rhizome Development':
        return l10n.rhizomeDevelopment;
      case 'Capsule Development':
        return l10n.capsuleDevelopment;
      case 'Nursery':
        return l10n.nursery;
      case 'Plucking':
        return l10n.plucking;
      case 'Young Plantation':
        return l10n.youngPlantation;
      case 'Full Bearing':
        return l10n.fullBearing;
      case 'Immature':
        return l10n.immature;
      case 'Tapping':
        return l10n.tapping;
      case 'Tuber Development':
        return l10n.tuberDevelopment;
      case 'Corm Development':
        return l10n.cormDevelopment;
      case 'Cutting':
        return l10n.cutting;
      case 'Bud':
        return l10n.bud;
      case 'Establishment':
        return l10n.establishment;
      case 'Bud Initiation':
        return l10n.budInitiation;
      case 'Spike Emergence':
        return l10n.spikeEmergence;
      case 'Pod Fill':
        return l10n.podFill;
      case 'Root Development':
        return l10n.rootDevelopment;
      case 'Root Swelling':
        return l10n.rootSwelling;
      case 'Bud Break':
        return l10n.budBreak;
      case 'Flower Induction':
        return l10n.flowerInduction;
      default:
        return stage;
    }
  }

  String _getLocalizedSoilType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case 'Loamy':
        return l10n.soilLoamy;
      case 'Clay':
        return l10n.soilClay;
      case 'Sandy':
        return l10n.soilSandy;
      case 'Black':
        return l10n.soilBlack;
      case 'Red':
        return l10n.soilRed;
      case 'Alluvial':
        return l10n.soilAlluvial;
      case 'Saline':
        return l10n.soilSaline;
      default:
        return type;
    }
  }

  String _getLocalizedIssue(BuildContext context, String issue) {
    final l10n = AppLocalizations.of(context);
    switch (issue) {
      case 'Yellow leaves':
        return l10n.issueYellowLeaves;
      case 'Stunted growth':
        return l10n.issueStuntedGrowth;
      case 'Pest attack':
        return l10n.issuePestAttack;
      case 'Fungal disease':
        return l10n.issueFungalDisease;
      case 'Wilting':
        return l10n.issueWilting;
      case 'Low yield':
        return l10n.issueLowYield;
      default:
        return issue;
    }
  }

  String _getLocalizedFertilizerName(BuildContext context, String name) {
    final l10n = AppLocalizations.of(context);
    final n = name.toLowerCase();
    if (n.contains("urea")) return l10n.fertUrea;
    if (n.contains("dap")) return l10n.fertDAP;
    if (n.contains("mop")) return l10n.fertMOP;
    if (n.contains("tsp")) return l10n.fertTSP;
    if (n.contains("ssp")) return l10n.fertSSP;
    if (n.contains("can")) return l10n.fertCAN;
    if (n.contains("sop") || n.contains("sulphate of potash")) {
      return l10n.fertSOP;
    }
    if (n.contains("19:19:19") || n.contains("npk")) return l10n.fertNPK19;
    if (n.contains("growth promoter") || n.contains("seaweed")) {
      return l10n.fertGrowthPromoter;
    }
    return name;
  }

  String _getLocalizedMethod(BuildContext context, String method) {
    final l10n = AppLocalizations.of(context);
    switch (method) {
      case 'Broadcast':
        return l10n.methodBroadcast;
      case 'Top Dressing':
        return l10n.methodTopDressing;
      case 'Soil Placement (Drilling)':
        return l10n.methodSoilPlacement;
      case 'Foliar Spray':
        return l10n.methodFoliarSpray;
      default:
        return method;
    }
  }

  String _getLocalizedTime(BuildContext context, String time) {
    final l10n = AppLocalizations.of(context);
    if (time.contains("Basal / Early Stage")) return l10n.timeBasalEarly;
    if (time.contains("3 doses")) return l10n.timeSplit3Doses;
    if (time.contains("1/2 now")) return l10n.timeSplit2Doses;
    if (time.contains("Basal (At Sowing)")) return l10n.timeBasalSowing;
    if (time.contains("applied in evening")) return l10n.timeEvening;
    return time;
  }

  String _getLocalizedPrecaution(BuildContext context, String precaution) {
    final l10n = AppLocalizations.of(context);
    if (precaution.contains("Heavy rain forecast")) return l10n.precHighRain;
    if (precaution.contains("Contains Calcium")) return l10n.precAcidicSoil;
    if (precaution.contains("leaf coverage")) return l10n.precLeafCoverage;
    if (precaution.contains("Mix well with water")) return l10n.precMixWater;
    return precaution;
  }

  String _getLocalizedAdvice(BuildContext context, String advice) {
    final l10n = AppLocalizations.of(context);
    if (advice.contains("Normal irrigation schedule")) {
      return l10n.adviceNormalIrrigation;
    }
    if (advice.contains("prevent leaching")) return l10n.adviceRainWarning;
    if (advice.contains("High temperature detected")) {
      return l10n.adviceHeatWarning;
    }
    return advice;
  }

  String _getLocalizedOrganic(BuildContext context, String organic) {
    final l10n = AppLocalizations.of(context);
    if (organic.contains("Farm Yard Manure")) return l10n.orgFYM;
    if (organic.contains("Vermicompost")) return l10n.orgVermicompost;
    if (organic.contains("Green Manure")) return l10n.orgGreenManure;
    if (organic.contains("Bio-fertilizers")) return l10n.orgBioFertilizer;
    return organic;
  }

  String _getLocalizedMicro(BuildContext context, String micro) {
    final l10n = AppLocalizations.of(context);
    if (micro.contains("Zinc Sulphate")) return l10n.microZinc;
    if (micro.contains("Ferrous Sulphate")) return l10n.microIron;
    if (micro.contains("Zinc is critical for Paddy")) {
      return l10n.microZincPaddy;
    }
    return micro;
  }

  Widget _buildShimmerCrop() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 60, height: 10, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildViewAllCard(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.grid_view_rounded,
            color: Colors.green[700],
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context).all,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSelectedCropDisplay() {
    return Consumer<CropController>(
      builder: (context, cropController, child) {
        final selectedCrop = cropController.selectedCrop;

        if (selectedCrop == null) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              AppLocalizations.of(context).selectCrop,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[300]!, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: selectedCrop.imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).selectCrop,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getLocalizedCropName(context, selectedCrop.name),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      selectedCrop.scientificName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.check_circle, color: Colors.green[700], size: 28),
            ],
          ),
        );
      },
    );
  }

  // Updated to accept AdvisoryController
  void _showAllCropsModal(
    BuildContext context,
    AdvisoryController advisoryController,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<CropController>(
              builder: (context, controller, _) {
                // Display all crops in the modal
                final allCrops = controller.allCrops;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Text(
                            AppLocalizations.of(context).selectCrop,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).search,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 16,
                          ),
                        ),
                        onChanged: (val) => controller.searchCrops(val),
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: allCrops.length,
                        itemBuilder: (context, index) {
                          final crop = allCrops[index];
                          final isSelected =
                              controller.selectedCrop?.id == crop.id;
                          return GestureDetector(
                            onTap: () {
                              controller.selectCrop(crop);
                              // Update advisory controller growth stage using passed instance
                              if (crop.growthStages.isNotEmpty) {
                                advisoryController.setGrowthStage(
                                  crop.growthStages[0],
                                );
                              }
                              Navigator.pop(context);
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: crop.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _getLocalizedCropName(context, crop.name),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.black,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildGrowthStageSelector(
    BuildContext context,
    AdvisoryController advisoryController,
    Crop selectedCrop,
  ) {
    // Ensure selected stage is valid for current crop
    // Use a safety check for display
    final String currentStage = advisoryController.selectedGrowthStage;
    final String displayStage = selectedCrop.growthStages.contains(currentStage)
        ? currentStage
        : (selectedCrop.growthStages.isNotEmpty
              ? selectedCrop.growthStages[0]
              : "");

    // If mismatch, we should ideally trigger an update, but modifying state during build is bad.
    // The previous update logic in selectCrop() handles the state update.
    // This just ensures the dropdown doesn't crash visually.

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: displayStage.isNotEmpty ? displayStage : null,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_circle, color: Colors.green),
          items: selectedCrop.growthStages.map((String stage) {
            return DropdownMenuItem<String>(
              value: stage,
              child: Text(_getLocalizedGrowthStage(context, stage)),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) advisoryController.setGrowthStage(val);
          },
        ),
      ),
    );
  }

  Widget _buildFieldSizeSlider(
    BuildContext context,
    AdvisoryController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).fieldSize,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${controller.fieldSize.toStringAsFixed(1)} ${controller.isHectares ? 'Ha' : AppLocalizations.of(context).acres}",
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: controller.fieldSize,
          min: 0.5,
          max: 50.0,
          divisions: 99,
          activeColor: Colors.green,
          inactiveColor: Colors.green[200],
          onChanged: (val) => controller.setFieldSize(val),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(AppLocalizations.of(context).acres),
            Switch(
              value: controller.isHectares,
              activeThumbColor: Colors.green,
              onChanged: (val) => controller.toggleUnit(val),
            ),
            Text(AppLocalizations.of(context).hectares),
          ],
        ),
      ],
    );
  }

  Widget _buildSoilHealthSection(
    BuildContext context,
    AdvisoryController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(AppLocalizations.of(context).soilHealth),
        const SizedBox(height: 12),
        // Soil Type Dropdown
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).soilHealth,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          initialValue: controller.selectedSoilType,
          items:
              ["Loamy", "Clay", "Sandy", "Black", "Red", "Alluvial", "Saline"]
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(_getLocalizedSoilType(context, t)),
                    ),
                  )
                  .toList(),
          onChanged: (val) {
            if (val != null) controller.setSoilType(val);
          },
        ),
      ],
    );
  }

  Widget _buildCropIssuesSection(
    BuildContext context,
    AdvisoryController controller,
  ) {
    List<String> issues = [
      "Yellow leaves",
      "Stunted growth",
      "Pest attack",
      "Fungal disease",
      "Wilting",
      "Low yield",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(AppLocalizations.of(context).cropIssues),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: issues.map((issue) {
            final isSelected = controller.selectedIssues.contains(issue);
            return FilterChip(
              label: Text(_getLocalizedIssue(context, issue)),
              selected: isSelected,
              selectedColor: Colors.red[100],
              checkmarkColor: Colors.red,
              labelStyle: TextStyle(
                color: isSelected ? Colors.red[900] : Colors.black87,
              ),
              onSelected: (_) => controller.toggleIssue(issue),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCalculateButton(
    BuildContext context,
    AdvisoryController advisoryController,
    CropController cropController,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        onPressed:
            advisoryController.isCalculating ||
                cropController.selectedCrop == null
            ? null
            : () async {
                await advisoryController.calculateAdvisory(
                  cropController.selectedCrop!,
                );
                if (context.mounted &&
                    advisoryController.advisoryResult != null) {
                  // Increment advisory used count
                  context.read<ProfileController>().incrementAdvisoryCount();
                }
              },
        child: Text(
          AppLocalizations.of(context).calculateAdvisory,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildResultSection(BuildContext context, AdvisoryResponse result) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(thickness: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).calculateAdvisory,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (result.rainWarning)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).rainExpectedWarning,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Recommendations List
          ...result.recommendations.map(
            (rec) => _buildFertilizerCard(context, rec),
          ),

          const SizedBox(height: 16),
          _buildInfoCard(
            AppLocalizations.of(context).irrigation,
            _getLocalizedAdvice(context, result.irrigationAdvice),
            Icons.water,
          ),

          if (result.micronutrients.isNotEmpty)
            _buildListCard(
              AppLocalizations.of(context).micronutrients,
              result.micronutrients
                  .map((e) => _getLocalizedMicro(context, e))
                  .toList(),
              Icons.science,
            ),

          if (result.organicAlternatives.isNotEmpty)
            _buildListCard(
              AppLocalizations.of(context).organicAlternatives,
              result.organicAlternatives
                  .map((e) => _getLocalizedOrganic(context, e))
                  .toList(),
              Icons.eco,
            ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              AppLocalizations.of(
                context,
              ).totalEstimatedCost(result.estimatedCost.toStringAsFixed(0)),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFertilizerCard(
    BuildContext context,
    FertilizerRecommendation rec,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _getLocalizedFertilizerName(context, rec.name),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  rec.npkRatio,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildDetailRow(
            AppLocalizations.of(context).quantity,
            "${rec.totalQuantity.toStringAsFixed(1)} ${AppLocalizations.of(context).kg} (${rec.quantityPerAcre.toStringAsFixed(1)} ${AppLocalizations.of(context).kgPerAcre})",
          ),
          _buildDetailRow(
            AppLocalizations.of(context).method,
            _getLocalizedMethod(context, rec.applicationMethod),
          ),
          _buildDetailRow(
            AppLocalizations.of(context).timing,
            _getLocalizedTime(context, rec.applicationTime),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).precautionsLabel,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          ...rec.precautions.map(
            (p) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _getLocalizedPrecaution(context, p),
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: TextStyle(color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _buildListCard(String title, List<String> items, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map(
            (i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text("• $i"),
            ),
          ),
        ],
      ),
    );
  }
}


