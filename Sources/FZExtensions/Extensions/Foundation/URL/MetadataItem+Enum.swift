//
//  File.swift
//  
//
//  Created by Florian Zand on 28.08.22.
//

import Foundation

extension MetadataQuery {
    public struct SortOption {
    public    var key: SortParamter
    public  var ascending: Bool
    public  init(_ key: SortParamter, ascending: Bool) {
        self.key = key
        self.ascending = ascending
    }
    internal var sortDescriptor: NSSortDescriptor {
        return NSSortDescriptor(key: key.rawValue, ascending: true) }
}

public enum SortParamter: String {
    case fsName = "kMDItemFSName"
    case displayName = "kMDItemDisplayName"
    case url = "kMDItemURL"
    case path = "kMDItemPath"
    case fsSize = "kMDItemFSSize"
    case fsCreationDate = "kMDItemFSCreationDate"
    case fsContentChangeDate = "kMDItemFSContentChangeDate"
    case contentType = "kMDItemContentType"
    case contentUTType = "kMDItemContentTypeTree"
    case attributeChangeDate = "kMDItemAttributeChangeDate"
    case keywords = "kMDItemwords"
    case title = "kMDItemTitle"
    case authors = "kMDItemAuthors"
    case editors = "kMDItemEditors"
    case participants = "kMDItemParticipants"
    case projects = "kMDItemProjects"
    case downloadedDate = "kMDItemDownloadedDate"
    case whereFroms = "kMDItemWhereFroms"
    case comment = "kMDItemComment"
    case copyright = "kMDItemCopyright"
    case lastUsedDate = "kMDItemLastUsedDate"
    case contentCreationDate = "kMDItemContentCreationDate"
    case contentModificationDate = "kMDItemContentModificationDate"
    case dateAdded = "kMDItemDateAdded"
    case durationSeconds = "kMDItemDurationSeconds"
    case contactKeywords = "kMDItemContactKeywords"
    case version = "kMDItemVersion"
    case pixelHeight = "kMDItemPixelHeight"
    case pixelWidth = "kMDItemPixelWidth"
    case pixelSize = "PixelSIZE"
    case pixelCount = "kMDItemPixelCount"
    case colorSpace = "kMDItemColorSpace"
    case bitsPerSample = "kMDItemBitsPerSample"
    case flashOnOff = "kMDItemFlashOnOff"
    case focalLength = "kMDItemFocalLength"
    case acquisitionMake = "kMDItemAcquisitionMake"
    case acquisitionModel = "kMDItemAcquisitionModel"
    case isoSpeed = "kMDItemISOSpeed"
    case orientation = "kMDItemOrientation"
    case layerNames = "kMDItemLayerNames"
    case whiteBalance = "kMDItemWhiteBalance"
    case aperture = "kMDItemAperture"
    case profileName = "kMDItemProfileName"
    case resolutionWidthDpi = "kMDItemResolutionWidthDPI"
    case resolutionHeightDpi = "kMDItemResolutionHeightDPI"
    case exposureMode = "kMDItemExposureMode"
    case exposureTimeSeconds = "kMDItemExposureTimeSeconds"
    case exifVersion = "kMDItemEXIFVersion"
    case cameraOwner = "kMDItemCameraOwner"
    case focalLength35Mm = "kMDItemFocalLength35mm"
    case lensModel = "kMDItemLensModel"
    case exifgpsVersion = "kMDItemEXIFGPSVersion"
    case altitude = "kMDItemAltitude"
    case latitude = "kMDItemLatitude"
    case longitude = "kMDItemLongitude"
    case speed = "kMDItemSpeed"
    case timestamp = "kMDItemTimestamp"
    case gpsTrack = "kMDItemGPSTrack"
    case imageDirection = "kMDItemImageDirection"
    case namedLocation = "kMDItemNamedLocation"
    case gpsStatus = "kMDItemGPSStatus"
    case gpsMeasureMode = "kMDItemGPSMeasureMode"
    case gpsdop = "kMDItemGPSDOP"
    case gpsMapDatum = "kMDItemGPSMapDatum"
    case gpsDestLatitude = "kMDItemGPSDestLatitude"
    case gpsDestLongitude = "kMDItemGPSDestLongitude"
    case gpsDestBearing = "kMDItemGPSDestBearing"
    case gpsDestDistance = "kMDItemGPSDestDistance"
    case gpsProcessingMethod = "kMDItemGPSProcessingMethod"
    case gpsAreaInformation = "kMDItemGPSAreaInformation"
    case gpsDateStamp = "kMDItemGPSDateStamp"
    case gpsDifferental = "kMDItemGPSDifferental"
    case codecs = "kMDItemCodecs"
    case mediaTypes = "kMDItemMediaTypes"
    case streamable = "kMDItemStreamable"
    case totalBitRate = "kMDItemTotalBitRate"
    case videoBitRate = "kMDItemVideoBitRate"
    case audioBitRate = "kMDItemAudioBitRate"
    case deliveryType = "kMDItemDeliveryType"
    case album = "kMDItemAlbum"
    case hasAlphaChannel = "kMDItemHasAlphaChannel"
    case redEyeOnOff = "kMDItemRedEyeOnOff"
    case meteringMode = "kMDItemMeteringMode"
    case maxAperture = "kMDItemMaxAperture"
    case fNumber = "kMDItemFNumber"
    case exposureProgram = "kMDItemExposureProgram"
    case exposureTimeString = "kMDItemExposureTimeString"
    case headline = "kMDItemHeadline"
    case instructions = "kMDItemInstructions"
    case city = "kMDItemCity"
    case stateOrProvince = "kMDItemStateOrProvince"
    case country = "kMDItemCountry"
    case textContent = "kMDItemTextContent"
    case audioSampleRate = "kMDItemAudioSampleRate"
    case audioChannelCount = "kMDItemAudioChannelCount"
    case tempo = "kMDItemTempo"
    case keySignature = "kMDItemSignature"
    case timeSignature = "kMDItemTimeSignature"
    case audioEncodingApplication = "kMDItemAudioEncodingApplication"
    case composer = "kMDItemComposer"
    case lyricist = "kMDItemLyricist"
    case audioTrackNumber = "kMDItemAudioTrackNumber"
    case recordingDate = "kMDItemRecordingDate"
    case musicalGenre = "kMDItemMusicalGenre"
    case isGeneralMidiSequence = "kMDItemIsGeneralMIDISequence"
    case recordingYear = "kMDItemRecordingYear"
    case organizations = "kMDItemOrganizations"
    case languages = "kMDItemLanguages"
    case rights = "kMDItemRights"
    case publishers = "kMDItemPublishers"
    case contributors = "kMDItemContributors"
    case coverage = "kMDItemCoverage"
    case subject = "kMDItemSubject"
    case theme = "kMDItemTheme"
    case description = "kMDItemDescription"
    case identifier = "kMDItemIdentifier"
    case audiences = "kMDItemAudiences"
    case numberOfPages = "kMDItemNumberOfPages"
    case pageWidth = "kMDItemPageWidth"
    case pageHeight = "kMDItemPageHeight"
    case securityMethod = "kMDItemSecurityMethod"
    case creator = "kMDItemCreator"
    case encodingApplications = "kMDItemEncodingApplications"
    case dueDate = "kMDItemDueDate"
    case starRating = "kMDItemStarRating"
    case phoneNumbers = "kMDItemPhoneNumbers"
    case emailAddresses = "kMDItemEmailAddresses"
    case instantMessageAddresses = "kMDItemInstantMessageAddresses"
    case kind = "kMDItemKind"
    case recipients = "kMDItemRecipients"
    case finderComment = "kMDItemFinderComment"
    case fonts = "kMDItemFonts"
    case appleLoopsRootKey = "kMDItemAppleLoopsRootKey"
    case appleLoopsKeyFilterType = "kMDItemAppleLoopsKeyFilterType"
    case appleLoopsLoopMode = "kMDItemAppleLoopsLoopMode"
    case appleLoopDescriptors = "kMDItemAppleLoopDescriptors"
    case musicalInstrumentCategory = "kMDItemMusicalInstrumentCategory"
    case musicalInstrumentName = "kMDItemMusicalInstrumentName"
    case cfBundleIdentifier = "kMDItemCFBundleIdentifier"
    case information = "kMDItemInformation"
    case director = "kMDItemDirector"
    case producer = "kMDItemProducer"
    case genre = "kMDItemGenre"
    case performers = "kMDItemPerformers"
    case originalFormat = "kMDItemOriginalFormat"
    case originalSource = "kMDItemOriginalSource"
    case authorEmailAddresses = "kMDItemAuthorEmailAddresses"
    case recipientEmailAddresses = "kMDItemRecipientEmailAddresses"
    case authorAddresses = "kMDItemAuthorAddresses"
    case recipientAddresses = "kMDItemRecipientAddresses"
    case isLikelyJunk = "kMDItemIsLikelyJunk"
    case executableArchitectures = "kMDItemExecutableArchitectures"
    case executablePlatform = "kMDItemExecutablePlatform"
    case applicationCategories = "kMDItemApplicationCategories"
    case isApplicationManaged = "kMDItemIsApplicationManaged"
    case isScreenCapture = "kMDItemIsScreenCapture"
    case queryResultContentRelevance = "kMDQueryResultContentRelevance"
    } 
}
