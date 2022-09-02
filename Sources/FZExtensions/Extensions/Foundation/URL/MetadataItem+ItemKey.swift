//
//  URLMetadata+MDItemKey.swift
//  FZCollection
//
//  Created by Florian Zand on 22.05.22.
//

import Foundation

#if os(macOS)
public extension PartialKeyPath where Root == MetadataItem {
    var mdItemKey: String {
        if #available(macOS 11.0, iOS 14.0, *) {
            if (self == \.contentUTType) {
                return "kMDItemContentTypeTree" } }
        
        if #available(macOS 10.12, *) {
            switch self {
            case \Root.keywords: return "kMDItemwords"
            case \Root.title: return "kMDItemTitle"
            case \Root.authors: return "kMDItemAuthors"
            case \Root.editors: return "kMDItemEditors"
            case \Root.participants: return "kMDItemParticipants"
            case \Root.projects: return "kMDItemProjects"
            case \Root.downloadedDate: return "kMDItemDownloadedDate"
            case \Root.whereFroms: return "kMDItemWhereFroms"
            case \Root.comment: return "kMDItemComment"
            case \Root.copyright: return "kMDItemCopyright"
            case \Root.lastUsedDate: return "kMDItemLastUsedDate"
            case \Root.contentCreationDate: return "kMDItemContentCreationDate"
            case \Root.contentModificationDate: return "kMDItemContentModificationDate"
            case \Root.dateAdded: return "kMDItemDateAdded"
            case \Root.durationSeconds: return "kMDItemDurationSeconds"
            case \Root.contactKeywords: return "kMDItemContactKeywords"
            case \Root.version: return "kMDItemVersion"
            case \Root.pixelHeight: return "kMDItemPixelHeight"
            case \Root.pixelWidth: return "kMDItemPixelWidth"
            case \Root.pixelSize: return "PixelSIZE"
            case \Root.pixelCount: return "kMDItemPixelCount"
            case \Root.colorSpace: return "kMDItemColorSpace"
            case \Root.bitsPerSample: return "kMDItemBitsPerSample"
            case \Root.flashOnOff: return "kMDItemFlashOnOff"
            case \Root.focalLength: return "kMDItemFocalLength"
            case \Root.acquisitionMake: return "kMDItemAcquisitionMake"
            case \Root.acquisitionModel: return "kMDItemAcquisitionModel"
            case \Root.isoSpeed: return "kMDItemISOSpeed"
            case \Root.orientation: return "kMDItemOrientation"
            case \Root.layerNames: return "kMDItemLayerNames"
            case \Root.whiteBalance: return "kMDItemWhiteBalance"
            case \Root.aperture: return "kMDItemAperture"
            case \Root.profileName: return "kMDItemProfileName"
            case \Root.resolutionWidthDpi: return "kMDItemResolutionWidthDPI"
            case \Root.resolutionHeightDpi: return "kMDItemResolutionHeightDPI"
            case \Root.exposureMode: return "kMDItemExposureMode"
            case \Root.exposureTimeSeconds: return "kMDItemExposureTimeSeconds"
            case \Root.exifVersion: return "kMDItemEXIFVersion"
            case \Root.cameraOwner: return "kMDItemCameraOwner"
            case \Root.focalLength35Mm: return "kMDItemFocalLength35mm"
            case \Root.lensModel: return "kMDItemLensModel"
            case \Root.exifgpsVersion: return "kMDItemEXIFGPSVersion"
            case \Root.altitude: return "kMDItemAltitude"
            case \Root.latitude: return "kMDItemLatitude"
            case \Root.longitude: return "kMDItemLongitude"
            case \Root.speed: return "kMDItemSpeed"
            case \Root.timestamp: return "kMDItemTimestamp"
            case \Root.gpsTrack: return "kMDItemGPSTrack"
            case \Root.imageDirection: return "kMDItemImageDirection"
            case \Root.namedLocation: return "kMDItemNamedLocation"
            case \Root.gpsStatus: return "kMDItemGPSStatus"
            case \Root.gpsMeasureMode: return "kMDItemGPSMeasureMode"
            case \Root.gpsdop: return "kMDItemGPSDOP"
            case \Root.gpsMapDatum: return "kMDItemGPSMapDatum"
            case \Root.gpsDestLatitude: return "kMDItemGPSDestLatitude"
            case \Root.gpsDestLongitude: return "kMDItemGPSDestLongitude"
            case \Root.gpsDestBearing: return "kMDItemGPSDestBearing"
            case \Root.gpsDestDistance: return "kMDItemGPSDestDistance"
            case \Root.gpsProcessingMethod: return "kMDItemGPSProcessingMethod"
            case \Root.gpsAreaInformation: return "kMDItemGPSAreaInformation"
            case \Root.gpsDateStamp: return "kMDItemGPSDateStamp"
            case \Root.gpsDifferental: return "kMDItemGPSDifferental"
            case \Root.codecs: return "kMDItemCodecs"
            case \Root.mediaTypes: return "kMDItemMediaTypes"
            case \Root.streamable: return "kMDItemStreamable"
            case \Root.totalBitRate: return "kMDItemTotalBitRate"
            case \Root.videoBitRate: return "kMDItemVideoBitRate"
            case \Root.audioBitRate: return "kMDItemAudioBitRate"
            case \Root.deliveryType: return "kMDItemDeliveryType"
            case \Root.album: return "kMDItemAlbum"
            case \Root.hasAlphaChannel: return "kMDItemHasAlphaChannel"
            case \Root.redEyeOnOff: return "kMDItemRedEyeOnOff"
            case \Root.meteringMode: return "kMDItemMeteringMode"
            case \Root.maxAperture: return "kMDItemMaxAperture"
            case \Root.fNumber: return "kMDItemFNumber"
            case \Root.exposureProgram: return "kMDItemExposureProgram"
            case \Root.exposureTimeString: return "kMDItemExposureTimeString"
            case \Root.headline: return "kMDItemHeadline"
            case \Root.instructions: return "kMDItemInstructions"
            case \Root.city: return "kMDItemCity"
            case \Root.stateOrProvince: return "kMDItemStateOrProvince"
            case \Root.country: return "kMDItemCountry"
            case \Root.textContent: return "kMDItemTextContent"
            case \Root.audioSampleRate: return "kMDItemAudioSampleRate"
            case \Root.audioChannelCount: return "kMDItemAudioChannelCount"
            case \Root.tempo: return "kMDItemTempo"
            case \Root.keySignature: return "kMDItemSignature"
            case \Root.timeSignature: return "kMDItemTimeSignature"
            case \Root.audioEncodingApplication: return "kMDItemAudioEncodingApplication"
            case \Root.composer: return "kMDItemComposer"
            case \Root.lyricist: return "kMDItemLyricist"
            case \Root.audioTrackNumber: return "kMDItemAudioTrackNumber"
            case \Root.recordingDate: return "kMDItemRecordingDate"
            case \Root.musicalGenre: return "kMDItemMusicalGenre"
            case \Root.isGeneralMidiSequence: return "kMDItemIsGeneralMIDISequence"
            case \Root.recordingYear: return "kMDItemRecordingYear"
            case \Root.organizations: return "kMDItemOrganizations"
            case \Root.languages: return "kMDItemLanguages"
            case \Root.rights: return "kMDItemRights"
            case \Root.publishers: return "kMDItemPublishers"
            case \Root.contributors: return "kMDItemContributors"
            case \Root.coverage: return "kMDItemCoverage"
            case \Root.subject: return "kMDItemSubject"
            case \Root.theme: return "kMDItemTheme"
            case \Root.description: return "kMDItemDescription"
            case \Root.identifier: return "kMDItemIdentifier"
            case \Root.audiences: return "kMDItemAudiences"
            case \Root.numberOfPages: return "kMDItemNumberOfPages"
            case \Root.pageWidth: return "kMDItemPageWidth"
            case \Root.pageHeight: return "kMDItemPageHeight"
            case \Root.securityMethod: return "kMDItemSecurityMethod"
            case \Root.creator: return "kMDItemCreator"
            case \Root.encodingApplications: return "kMDItemEncodingApplications"
            case \Root.dueDate: return "kMDItemDueDate"
            case \Root.starRating: return "kMDItemStarRating"
            case \Root.phoneNumbers: return "kMDItemPhoneNumbers"
            case \Root.emailAddresses: return "kMDItemEmailAddresses"
            case \Root.instantMessageAddresses: return "kMDItemInstantMessageAddresses"
            case \Root.kind: return "kMDItemKind"
            case \Root.recipients: return "kMDItemRecipients"
            case \Root.finderComment: return "kMDItemFinderComment"
            case \Root.fonts: return "kMDItemFonts"
            case \Root.appleLoopsRootKey: return "kMDItemAppleLoopsRootKey"
            case \Root.appleLoopsKeyFilterType: return "kMDItemAppleLoopsKeyFilterType"
            case \Root.appleLoopsLoopMode: return "kMDItemAppleLoopsLoopMode"
            case \Root.appleLoopDescriptors: return "kMDItemAppleLoopDescriptors"
            case \Root.musicalInstrumentCategory: return "kMDItemMusicalInstrumentCategory"
            case \Root.musicalInstrumentName: return "kMDItemMusicalInstrumentName"
            case \Root.cfBundleIdentifier: return "kMDItemCFBundleIdentifier"
            case \Root.information: return "kMDItemInformation"
            case \Root.director: return "kMDItemDirector"
            case \Root.producer: return "kMDItemProducer"
            case \Root.genre: return "kMDItemGenre"
            case \Root.performers: return "kMDItemPerformers"
            case \Root.originalFormat: return "kMDItemOriginalFormat"
            case \Root.originalSource: return "kMDItemOriginalSource"
            case \Root.authorEmailAddresses: return "kMDItemAuthorEmailAddresses"
            case \Root.recipientEmailAddresses: return "kMDItemRecipientEmailAddresses"
            case \Root.authorAddresses: return "kMDItemAuthorAddresses"
            case \Root.recipientAddresses: return "kMDItemRecipientAddresses"
            case \Root.isLikelyJunk: return "kMDItemIsLikelyJunk"
            case \Root.executableArchitectures: return "kMDItemExecutableArchitectures"
            case \Root.executablePlatform: return "kMDItemExecutablePlatform"
            case \Root.applicationCategories: return "kMDItemApplicationCategories"
            case \Root.isApplicationManaged: return "kMDItemIsApplicationManaged"
            default:
                break
            }
        }
        
        switch self {
        case \Root.fsName: return "kMDItemFSName"
        case \Root.displayName: return "kMDItemDisplayName"
        case \Root.url: return "kMDItemURL"
        case \Root.path: return "kMDItemPath"
        case \Root.fsSize: return "kMDItemFSSize"
        case \Root.fsCreationDate: return "kMDItemFSCreationDate"
        case \Root.fsContentChangeDate: return "kMDItemFSContentChangeDate"
        case \Root.contentType: return "kMDItemContentType"
        case \Root.contentTypeTree: return "kMDItemContentTypeTree"
        case \Root.attributeChangeDate: return "kMDItemAttributeChangeDate"
        case \Root.isScreenCapture: return "kMDItemIsScreenCapture"
        case \Root.queryResultContentRelevance: return "kMDQueryResultContentRelevance"
        default: return "kMDItemTextContent"
        }
    }
}
#elseif canImport(UIKit)
public extension PartialKeyPath where Root == MetadataItem {
    var mdItemKey: String {
        if #available(macOS 11.0, iOS 14.0, *) {
            if (self == \.contentUTType) {
                return "kMDItemContentTypeTree" } }
                
        switch self {
        case \Root.fsName: return "kMDItemFSName"
        case \Root.displayName: return "kMDItemDisplayName"
        case \Root.url: return "kMDItemURL"
        case \Root.path: return "kMDItemPath"
        case \Root.fsSize: return "kMDItemFSSize"
        case \Root.fsCreationDate: return "kMDItemFSCreationDate"
        case \Root.fsContentChangeDate: return "kMDItemFSContentChangeDate"
        case \Root.contentType: return "kMDItemContentType"
        case \Root.contentTypeTree: return "kMDItemContentTypeTree"
        case \Root.attributeChangeDate: return "kMDItemAttributeChangeDate"
        case \Root.isScreenCapture: return "kMDItemIsScreenCapture"
        case \Root.queryResultContentRelevance: return "kMDQueryResultContentRelevance"
        default: return "kMDItemTextContent"
        }
    }
}
#endif
