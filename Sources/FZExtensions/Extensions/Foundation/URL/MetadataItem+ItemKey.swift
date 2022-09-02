//
//  URLMetadata+MDItemKey.swift
//  FZCollection
//
//  Created by Florian Zand on 22.05.22.
//

import Foundation

public extension PartialKeyPath where Root == MetadataItem {
    var mdItemKey: String {
        if #available(macOS 11.0, iOS 14.0, *) {
            if (self == \.contentUTType) {
                return "kMDItemContentTypeTree" } }
        
        if #available(macOS 10.12, *) {
            switch self {
            case \.keywords: return "kMDItemwords"
            case \.title: return "kMDItemTitle"
            case \.authors: return "kMDItemAuthors"
            case \.editors: return "kMDItemEditors"
            case \.participants: return "kMDItemParticipants"
            case \.projects: return "kMDItemProjects"
            case \.downloadedDate: return "kMDItemDownloadedDate"
            case \.whereFroms: return "kMDItemWhereFroms"
            case \.comment: return "kMDItemComment"
            case \.copyright: return "kMDItemCopyright"
            case \.lastUsedDate: return "kMDItemLastUsedDate"
            case \.contentCreationDate: return "kMDItemContentCreationDate"
            case \.contentModificationDate: return "kMDItemContentModificationDate"
            case \.dateAdded: return "kMDItemDateAdded"
            case \.durationSeconds: return "kMDItemDurationSeconds"
            case \.contactKeywords: return "kMDItemContactKeywords"
            case \.version: return "kMDItemVersion"
            case \.pixelHeight: return "kMDItemPixelHeight"
            case \.pixelWidth: return "kMDItemPixelWidth"
            case \.pixelSize: return "PixelSIZE"
            case \.pixelCount: return "kMDItemPixelCount"
            case \.colorSpace: return "kMDItemColorSpace"
            case \.bitsPerSample: return "kMDItemBitsPerSample"
            case \.flashOnOff: return "kMDItemFlashOnOff"
            case \.focalLength: return "kMDItemFocalLength"
            case \.acquisitionMake: return "kMDItemAcquisitionMake"
            case \.acquisitionModel: return "kMDItemAcquisitionModel"
            case \.isoSpeed: return "kMDItemISOSpeed"
            case \.orientation: return "kMDItemOrientation"
            case \.layerNames: return "kMDItemLayerNames"
            case \.whiteBalance: return "kMDItemWhiteBalance"
            case \.aperture: return "kMDItemAperture"
            case \.profileName: return "kMDItemProfileName"
            case \.resolutionWidthDpi: return "kMDItemResolutionWidthDPI"
            case \.resolutionHeightDpi: return "kMDItemResolutionHeightDPI"
            case \.exposureMode: return "kMDItemExposureMode"
            case \.exposureTimeSeconds: return "kMDItemExposureTimeSeconds"
            case \.exifVersion: return "kMDItemEXIFVersion"
            case \.cameraOwner: return "kMDItemCameraOwner"
            case \.focalLength35Mm: return "kMDItemFocalLength35mm"
            case \.lensModel: return "kMDItemLensModel"
            case \.exifgpsVersion: return "kMDItemEXIFGPSVersion"
            case \.altitude: return "kMDItemAltitude"
            case \.latitude: return "kMDItemLatitude"
            case \.longitude: return "kMDItemLongitude"
            case \.speed: return "kMDItemSpeed"
            case \.timestamp: return "kMDItemTimestamp"
            case \.gpsTrack: return "kMDItemGPSTrack"
            case \.imageDirection: return "kMDItemImageDirection"
            case \.namedLocation: return "kMDItemNamedLocation"
            case \.gpsStatus: return "kMDItemGPSStatus"
            case \.gpsMeasureMode: return "kMDItemGPSMeasureMode"
            case \.gpsdop: return "kMDItemGPSDOP"
            case \.gpsMapDatum: return "kMDItemGPSMapDatum"
            case \.gpsDestLatitude: return "kMDItemGPSDestLatitude"
            case \.gpsDestLongitude: return "kMDItemGPSDestLongitude"
            case \.gpsDestBearing: return "kMDItemGPSDestBearing"
            case \.gpsDestDistance: return "kMDItemGPSDestDistance"
            case \.gpsProcessingMethod: return "kMDItemGPSProcessingMethod"
            case \.gpsAreaInformation: return "kMDItemGPSAreaInformation"
            case \.gpsDateStamp: return "kMDItemGPSDateStamp"
            case \.gpsDifferental: return "kMDItemGPSDifferental"
            case \.codecs: return "kMDItemCodecs"
            case \.mediaTypes: return "kMDItemMediaTypes"
            case \.streamable: return "kMDItemStreamable"
            case \.totalBitRate: return "kMDItemTotalBitRate"
            case \.videoBitRate: return "kMDItemVideoBitRate"
            case \.audioBitRate: return "kMDItemAudioBitRate"
            case \.deliveryType: return "kMDItemDeliveryType"
            case \.album: return "kMDItemAlbum"
            case \.hasAlphaChannel: return "kMDItemHasAlphaChannel"
            case \.redEyeOnOff: return "kMDItemRedEyeOnOff"
            case \.meteringMode: return "kMDItemMeteringMode"
            case \.maxAperture: return "kMDItemMaxAperture"
            case \.fNumber: return "kMDItemFNumber"
            case \.exposureProgram: return "kMDItemExposureProgram"
            case \.exposureTimeString: return "kMDItemExposureTimeString"
            case \.headline: return "kMDItemHeadline"
            case \.instructions: return "kMDItemInstructions"
            case \.city: return "kMDItemCity"
            case \.stateOrProvince: return "kMDItemStateOrProvince"
            case \.country: return "kMDItemCountry"
            case \.textContent: return "kMDItemTextContent"
            case \.audioSampleRate: return "kMDItemAudioSampleRate"
            case \.audioChannelCount: return "kMDItemAudioChannelCount"
            case \.tempo: return "kMDItemTempo"
            case \.keySignature: return "kMDItemSignature"
            case \.timeSignature: return "kMDItemTimeSignature"
            case \.audioEncodingApplication: return "kMDItemAudioEncodingApplication"
            case \.composer: return "kMDItemComposer"
            case \.lyricist: return "kMDItemLyricist"
            case \.audioTrackNumber: return "kMDItemAudioTrackNumber"
            case \.recordingDate: return "kMDItemRecordingDate"
            case \.musicalGenre: return "kMDItemMusicalGenre"
            case \.isGeneralMidiSequence: return "kMDItemIsGeneralMIDISequence"
            case \.recordingYear: return "kMDItemRecordingYear"
            case \.organizations: return "kMDItemOrganizations"
            case \.languages: return "kMDItemLanguages"
            case \.rights: return "kMDItemRights"
            case \.publishers: return "kMDItemPublishers"
            case \.contributors: return "kMDItemContributors"
            case \.coverage: return "kMDItemCoverage"
            case \.subject: return "kMDItemSubject"
            case \.theme: return "kMDItemTheme"
            case \.description: return "kMDItemDescription"
            case \.identifier: return "kMDItemIdentifier"
            case \.audiences: return "kMDItemAudiences"
            case \.numberOfPages: return "kMDItemNumberOfPages"
            case \.pageWidth: return "kMDItemPageWidth"
            case \.pageHeight: return "kMDItemPageHeight"
            case \.securityMethod: return "kMDItemSecurityMethod"
            case \.creator: return "kMDItemCreator"
            case \.encodingApplications: return "kMDItemEncodingApplications"
            case \.dueDate: return "kMDItemDueDate"
            case \.starRating: return "kMDItemStarRating"
            case \.phoneNumbers: return "kMDItemPhoneNumbers"
            case \.emailAddresses: return "kMDItemEmailAddresses"
            case \.instantMessageAddresses: return "kMDItemInstantMessageAddresses"
            case \.kind: return "kMDItemKind"
            case \.recipients: return "kMDItemRecipients"
            case \.finderComment: return "kMDItemFinderComment"
            case \.fonts: return "kMDItemFonts"
            case \.appleLoopsRootKey: return "kMDItemAppleLoopsRootKey"
            case \.appleLoopsKeyFilterType: return "kMDItemAppleLoopsKeyFilterType"
            case \.appleLoopsLoopMode: return "kMDItemAppleLoopsLoopMode"
            case \.appleLoopDescriptors: return "kMDItemAppleLoopDescriptors"
            case \.musicalInstrumentCategory: return "kMDItemMusicalInstrumentCategory"
            case \.musicalInstrumentName: return "kMDItemMusicalInstrumentName"
            case \.cfBundleIdentifier: return "kMDItemCFBundleIdentifier"
            case \.information: return "kMDItemInformation"
            case \.director: return "kMDItemDirector"
            case \.producer: return "kMDItemProducer"
            case \.genre: return "kMDItemGenre"
            case \.performers: return "kMDItemPerformers"
            case \.originalFormat: return "kMDItemOriginalFormat"
            case \.originalSource: return "kMDItemOriginalSource"
            case \.authorEmailAddresses: return "kMDItemAuthorEmailAddresses"
            case \.recipientEmailAddresses: return "kMDItemRecipientEmailAddresses"
            case \.authorAddresses: return "kMDItemAuthorAddresses"
            case \.recipientAddresses: return "kMDItemRecipientAddresses"
            case \.isLikelyJunk: return "kMDItemIsLikelyJunk"
            case \.executableArchitectures: return "kMDItemExecutableArchitectures"
            case \.executablePlatform: return "kMDItemExecutablePlatform"
            case \.applicationCategories: return "kMDItemApplicationCategories"
            case \.isApplicationManaged: return "kMDItemIsApplicationManaged"
            default:
                break
            }
        }
        
        switch self {
        case \.fsName: return "kMDItemFSName"
        case \.displayName: return "kMDItemDisplayName"
        case \.url: return "kMDItemURL"
        case \.path: return "kMDItemPath"
        case \.fsSize: return "kMDItemFSSize"
        case \.fsCreationDate: return "kMDItemFSCreationDate"
        case \.fsContentChangeDate: return "kMDItemFSContentChangeDate"
        case \.contentType: return "kMDItemContentType"
        case \.contentTypeTree: return "kMDItemContentTypeTree"
        case \.attributeChangeDate: return "kMDItemAttributeChangeDate"
        case \.isScreenCapture: return "kMDItemIsScreenCapture"
        case \.queryResultContentRelevance: return "kMDQueryResultContentRelevance"
        default: return "kMDItemTextContent"
        }
    }
}
