#
# Be sure to run `pod lib lint MKBXPSeriesSlathf.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MKBXPSeriesSlathf'
  s.version          = '0.0.1'
  s.summary          = 'A short description of MKBXPSeriesSlathf.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lovexiaoxia/MKBXPSeriesSlathf'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lovexiaoxia' => 'aadyx2007@163.com' }
  s.source           = { :git => 'https://github.com/lovexiaoxia/MKBXPSeriesSlathf.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '14.0'
  
  s.resource_bundles = {
    'MKBXPSeriesSlathf' => ['MKBXPSeriesSlathf/Assets/*.png']
  }
  
  s.subspec 'ConnectManager' do |ss|
    ss.source_files = 'MKBXPSeriesSlathf/Classes/ConnectManager/**'
    
    ss.dependency 'MKBaseModuleLibrary'
    
    ss.dependency 'MKBXPSeriesSlathf/SDK'
  end
  
  s.subspec 'CTMediator' do |ss|
    ss.source_files = 'MKBXPSeriesSlathf/Classes/CTMediator/**'
    
    ss.dependency 'CTMediator'
  end
  
  s.subspec 'SDK' do |ss|
    ss.source_files = 'MKBXPSeriesSlathf/Classes/SDK/**'
    ss.dependency 'MKBaseBleModule'
  end
  
  s.subspec 'Target' do |ss|
    ss.source_files = 'MKBXPSeriesSlathf/Classes/Target/**'
    
    ss.dependency 'MKBXPSeriesSlathf/Functions'
  end
  
  s.subspec 'Expand' do |ss|
    
    ss.subspec 'ExcelManager' do |sss|
      
      sss.source_files = 'MKBXPSeriesSlathf/Classes/Expand/ExcelManager/**'
    
    end
    
    ss.subspec 'View' do |sss|
      
      sss.subspec 'ExportDataHeaderView' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Expand/View/ExportDataHeaderView/**'
      end
      
      sss.subspec 'FilterHistoryDataView' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Expand/View/FilterHistoryDataView/**'
        
        ssss.dependency 'BRPickerView'
      end
      
      sss.subspec 'HistoryMaskView' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Expand/View/HistoryMaskView/**'
      end
      
      sss.subspec 'SyncTimeCell' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Expand/View/SyncTimeCell/**'
      end
      
      sss.subspec 'THCurveView' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Expand/View/THCurveView/**'
      end
        
    end
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
  
  end
  
  s.subspec 'Functions' do |ss|
    
    ss.subspec 'AboutPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/AboutPage/Controller/**'
      end
    end

    ss.subspec 'AccelerationPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/AccelerationPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/AccelerationPage/Model'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/AccelerationPage/View'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/AccelerationPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/AccelerationPage/View/**'
      end
    end
    
    ss.subspec 'DeviceInfoPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/DeviceInfoPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/DeviceInfoPage/Model'

      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/DeviceInfoPage/Model/**'
      end
    end

    ss.subspec 'ExportHTDataPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/ExportHTDataPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/ExportHTDataPage/View'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/FilterHTHistoryPage/Controller'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/ExportHTDataPage/View/**'
      end
    end
    
    ss.subspec 'ExportTempDataPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/ExportTempDataPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/ExportTempDataPage/View'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/FilterTempHistoryPage/Controller'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/ExportTempDataPage/View/**'
      end
    end
    
    ss.subspec 'FilterHallHistoryPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/FilterHallHistoryPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/FilterHallHistoryPage/View'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/FilterHallHistoryPage/View/**'
      end
    end
    
    ss.subspec 'FilterHTHistoryPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/FilterHTHistoryPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/FilterHTHistoryPage/View'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/FilterHTHistoryPage/View/**'
      end
    end
    
    ss.subspec 'FilterTempHistoryPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/FilterTempHistoryPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/FilterTempHistoryPage/View'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/FilterTempHistoryPage/View/**'
      end
    end
    
    ss.subspec 'HallSensorPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/HallSensorPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/HallSensorPage/Model'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/HallSensorPage/View'
        
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/HallSensorPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/HallSensorPage/View/**'
      end
    end
    
    ss.subspec 'OptionsPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/OptionsPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/OptionsPage/View'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/ScanPage/Controller'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/OptionsPage/View/**'
      end
    end
    
    ss.subspec 'QuickSwitchPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/QuickSwitchPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/QuickSwitchPage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/QuickSwitchPage/Model/**'
      end
    end
    
    ss.subspec 'RemoteReminderPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/RemoteReminderPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/RemoteReminderPage/Model'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/RemoteReminderPage/View'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/RemoteReminderPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/RemoteReminderPage/View/**'
      end
    end

    ss.subspec 'ScanPage' do |sss|
      sss.subspec 'Adopter' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/ScanPage/Adopter/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/ScanPage/Model'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/ScanPage/View'
      end
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/ScanPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/ScanPage/Model'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/ScanPage/View'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/ScanPage/Adopter'

        ssss.dependency 'MKBXPSeriesSlathf/Functions/TabBarPage/Controller'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/AboutPage/Controller'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/ScanPage/Model/**'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/ScanPage/View/**'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/ScanPage/Model'
      end
    end
    
    ss.subspec 'SensorConfigPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/SensorConfigPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/SensorConfigPage/Model'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/AccelerationPage'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/HallSensorPage'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/THSensorPage'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/TempSensorPage'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/SensorConfigPage/Model/**'
      end
    end

    ss.subspec 'SettingPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/SettingPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/SettingPage/Model'

        ssss.dependency 'MKBXPSeriesSlathf/Functions/SensorConfigPage/Controller'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/QuickSwitchPage/Controller'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/UpdatePage/Controller'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/RemoteReminderPage/Controller'
        
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/SettingPage/Model/**'
      end
    end

    ss.subspec 'SlotPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/SlotPage/Controller/**'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/SlotPage/Model'

        ssss.dependency 'MKBXPSeriesSlathf/Functions/TriggerPages'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/SlotPage/Model/**'
      end
    end

    ss.subspec 'TabBarPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TabBarPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/SlotPage/Controller'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/SettingPage/Controller'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/DeviceInfoPage/Controller'
      end
    end
    
    ss.subspec 'TempSensorPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TempSensorPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/TempSensorPage/View'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/TempSensorPage/Model'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TempSensorPage/View/**'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TempSensorPage/Model/**'
      end
    end
    
    ss.subspec 'THSensorPage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/THSensorPage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/THSensorPage/View'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/THSensorPage/Model'
      end
      sss.subspec 'View' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/THSensorPage/View/**'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/THSensorPage/Model/**'
      end
    end
    
    ss.subspec 'TriggerPages' do |sss|
      
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/TriggerPages/Defines'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/TriggerPages/Manager'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/TriggerPages/Model'
        ssss.dependency 'MKBXPSeriesSlathf/Functions/TriggerPages/View'
      end
      
      sss.subspec 'Defines' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/Defines/**'
      end
      
      sss.subspec 'Manager' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/Manager/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/TriggerPages/Model'
      end
      
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/Model/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/TriggerPages/Defines'
      end
      
      sss.subspec 'View' do |ssss|
        ssss.subspec 'SlotBeaconCell' do |sssss|
          sssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/View/SlotBeaconCell/**'
        end
        ssss.subspec 'SlotFramePickView' do |sssss|
          sssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/View/SlotFramePickView/**'
        end
        ssss.subspec 'SlotParamCell' do |sssss|
          sssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/View/SlotParamCell/**'
        end
        ssss.subspec 'SlotSersorInfoCell' do |sssss|
          sssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/View/SlotSersorInfoCell/**'
        end
        ssss.subspec 'SlotUIDCell' do |sssss|
          sssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/View/SlotUIDCell/**'
        end
        ssss.subspec 'SlotURLCell' do |sssss|
          sssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/View/SlotURLCell/**'
        end
        ssss.subspec 'TriggerSlotParamCell' do |sssss|
          sssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/TriggerPages/View/TriggerSlotParamCell/**'
        end
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/TriggerPages/Defines'
      end
      
    end
    
    ss.subspec 'UpdatePage' do |sss|
      sss.subspec 'Controller' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/UpdatePage/Controller/**'
        
        ssss.dependency 'MKBXPSeriesSlathf/Functions/UpdatePage/Model'
      end
      sss.subspec 'Model' do |ssss|
        ssss.source_files = 'MKBXPSeriesSlathf/Classes/Functions/UpdatePage/Model/**'
      end
    end

    ss.dependency 'MKBXPSeriesSlathf/ConnectManager'
    ss.dependency 'MKBXPSeriesSlathf/SDK'
    ss.dependency 'MKBXPSeriesSlathf/CTMediator'
    ss.dependency 'MKBXPSeriesSlathf/Expand'
    
    ss.dependency 'MKBaseModuleLibrary'
    ss.dependency 'MKCustomUIModule'
    ss.dependency 'MKBeaconXCustomUI'
    
    ss.dependency 'HHTransition'
    ss.dependency 'MLInputDodger'
    
  end
  
end
