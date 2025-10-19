
import 'package:flutter/material.dart';
import 'roi_calculator.dart';
import 'ctr_calculator.dart';
import 'cpc_calculator.dart';
import 'cpm_calculator.dart';
import 'conversion_rate_calculator.dart';
import 'bounce_rate_calculator.dart';
import 'clv_calculator.dart';
import 'cac_calculator.dart';
import 'roas_calculator.dart';
import 'gross_margin_calculator.dart';
import 'engagement_rate_calculator.dart';
import 'email_open_rate_calculator.dart';
import 'email_click_rate_calculator.dart';
import 'cpl_calculator.dart';
import 'video_cpm_calculator.dart';
import 'share_of_voice_calculator.dart';
import 'churn_rate_calculator.dart';
import 'retention_rate_calculator.dart';
import 'aov_calculator.dart';
import 'nps_calculator.dart';

class ScreensIndex {
  static Widget getScreen(String route) {
    switch(route) {
      case 'ROICalculator': return ROICalculator();
      case 'CTRCalculator': return CTRCalculator();
      case 'CPCCalculator': return CPCCalculator();
      case 'CPMCalculator': return CPMCalculator();
      case 'ConversionRateCalculator': return ConversionRateCalculator();
      case 'BounceRateCalculator': return BounceRateCalculator();
      case 'CLVCalculator': return CLVCalculator();
      case 'CACCalculator': return CACCalculator();
      case 'ROASCalculator': return ROASCalculator();
      case 'GrossMarginCalculator': return GrossMarginCalculator();
      case 'EngagementRateCalculator': return EngagementRateCalculator();
      case 'EmailOpenRateCalculator': return EmailOpenRateCalculator();
      case 'EmailClickRateCalculator': return EmailClickRateCalculator();
      case 'CPLCalculator': return CPLCalculator();
      case 'VideoCPMCalculator': return VideoCPMCalculator();
      case 'ShareOfVoiceCalculator': return ShareOfVoiceCalculator();
      case 'ChurnRateCalculator': return ChurnRateCalculator();
      case 'RetentionRateCalculator': return RetentionRateCalculator();
      case 'AOVCalculator': return AOVCalculator();
      case 'NPSCalculator': return NPSCalculator();
      default: return Scaffold(body: Center(child: Text('Screen not found')));
    }
  }
}
