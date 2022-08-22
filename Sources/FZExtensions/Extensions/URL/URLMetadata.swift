//
//  URLMetadata.swift
//  FZCollection
//
//  Created by Florian Zand on 24.04.22.
//

import Foundation

public extension URL {
    var metadata: URLMetadata? {
        return URLMetadata(url: self)
    }
}

public class URLMetadata {

    let item: NSMetadataItem

    init?(url: URL) {
        if let item = NSMetadataItem(url: url) {
            self.item = item
        } else {
            return nil
        }
    }
    
    init(item: NSMetadataItem) {
        self.item = item
    }
    
   private var attributes: [String] {
        return item.attributes
    }
    
    var url: URL? {
        get { item.value(forAttribute: NSMetadataItemURLKey) as? URL }
        // set { item.setValue(newValue, forKey: NSMetadataItemURLKey) }
    }
       
    var fsName: String? {
        get { item.value(forAttribute: NSMetadataItemFSNameKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemFSNameKey) }
    }
    
    var displayName: String? {
        get { item.value(forAttribute: NSMetadataItemDisplayNameKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemDisplayNameKey) }
    }
    
    var path: String? {
        get { item.value(forAttribute: NSMetadataItemPathKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemPathKey) }
    }
    
    var fsSize: Int? {
        get { item.value(forAttribute: NSMetadataItemFSSizeKey) as? Int }
        // set { item.setValue(newValue, forKey: NSMetadataItemFSSizeKey) }
    }
        
    var fsCreationDate: Date? {
        get { item.value(forAttribute: NSMetadataItemFSCreationDateKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemFSCreationDateKey) }
    }
    
    var fsContentChangeDate: Date? {
        get { item.value(forAttribute: NSMetadataItemFSContentChangeDateKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemFSContentChangeDateKey) }
    }
    
    var contentType: String? {
        get { item.value(forAttribute: NSMetadataItemContentTypeKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemContentTypeKey) }
    }
    
    var contentTypeTree: [String]? {
        get { item.value(forAttribute: NSMetadataItemContentTypeTreeKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemContentTypeTreeKey) }
    }
    
    var attributeChangeDate: Date? {
        get { item.value(forAttribute: NSMetadataItemAttributeChangeDateKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemAttributeChangeDateKey) }
    }
    var keywords: [String]? {
        get { item.value(forAttribute: NSMetadataItemKeywordsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemKeywordsKey) }
    }
    var title: String? {
        get { item.value(forAttribute: NSMetadataItemTitleKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemTitleKey) }
    }
    var authors: [String]? {
        get { item.value(forAttribute: NSMetadataItemAuthorsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemAuthorsKey) }
    }
    var editors: [String]? {
        get { item.value(forAttribute: NSMetadataItemEditorsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemEditorsKey) }
    }
    var participants: [String]? {
        get { item.value(forAttribute: NSMetadataItemParticipantsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemParticipantsKey) }
    }
    var projects: [String]? {
        get { item.value(forAttribute: NSMetadataItemProjectsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemProjectsKey) }
    }
    var downloadedDate: Date? {
        get { item.value(forAttribute: NSMetadataItemDownloadedDateKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemDownloadedDateKey) }
    }
    var whereFroms: [String]? {
        get { item.value(forAttribute: NSMetadataItemWhereFromsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemWhereFromsKey) }
    }
    
    var comment: String? {
        get { item.value(forAttribute: NSMetadataItemCommentKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemCommentKey) }
    }
    var copyright: String? {
        get { item.value(forAttribute: NSMetadataItemCopyrightKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemCopyrightKey) }
    }
    var lastUsedDate: Date? {
        get { item.value(forAttribute: NSMetadataItemLastUsedDateKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemLastUsedDateKey) }
    }
    var contentCreationDate: Date? {
        get { item.value(forAttribute: NSMetadataItemContentCreationDateKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemContentCreationDateKey) }
    }
    var contentModificationDate: Date? {
        get { item.value(forAttribute: NSMetadataItemContentModificationDateKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemContentModificationDateKey) }
    }
    var dateAdded: Date? {
        get { item.value(forAttribute: NSMetadataItemDateAddedKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemDateAddedKey) }
    }
    var durationSeconds: Double? {
        get { item.value(forAttribute: NSMetadataItemDurationSecondsKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemDurationSecondsKey) }
    }
    var contactKeywords: [String]? {
        get { item.value(forAttribute: NSMetadataItemContactKeywordsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemContactKeywordsKey) }
    }
    var version: String? {
        get { item.value(forAttribute: NSMetadataItemVersionKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemVersionKey) }
    }
    var pixelHeight: Double? {
        get { item.value(forAttribute: NSMetadataItemPixelHeightKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemPixelHeightKey) }
    }
    var pixelWidth: Double? {
        get { item.value(forAttribute: NSMetadataItemPixelWidthKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemPixelWidthKey) }
    }
    var pixelSize: CGSize? {
        get {
            if let height = item.value(forAttribute: NSMetadataItemPixelHeightKey) as? Double, let width = item.value(forAttribute: NSMetadataItemPixelWidthKey) as? Double {
                return CGSize(width: width, height: height)
            }
            return nil
        }
        /* set {
            if let newSize = newValue {
                item.setValue(newSize.height, forKey: NSMetadataItemPixelHeightKey)
                item.setValue(newSize.width, forKey: NSMetadataItemPixelWidthKey)
            } else {
                item.setValue(nil, forKey: NSMetadataItemPixelHeightKey)
                item.setValue(nil, forKey: NSMetadataItemPixelWidthKey)
            }
        } */
    }
    
    var pixelCount: Double? {
        get { item.value(forAttribute: NSMetadataItemPixelCountKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemPixelCountKey) }
    }
    var colorSpace: String? {
        get { item.value(forAttribute: NSMetadataItemColorSpaceKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemColorSpaceKey) }
    }
    var bitsPerSample: Double? {
        get { item.value(forAttribute: NSMetadataItemBitsPerSampleKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemBitsPerSampleKey) }
    }
    var flashOnOff: Bool? {
        get { item.value(forAttribute: NSMetadataItemFlashOnOffKey) as? Bool }
        // set { item.setValue(newValue, forKey: NSMetadataItemFlashOnOffKey) }
    }
    var focalLength: Double? {
        get { item.value(forAttribute: NSMetadataItemFocalLengthKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemFocalLengthKey) }
    }
    var acquisitionMake: String? {
        get { item.value(forAttribute: NSMetadataItemAcquisitionMakeKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemAcquisitionMakeKey) }
    }
    var acquisitionModel: String? {
        get { item.value(forAttribute: NSMetadataItemAcquisitionModelKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemAcquisitionModelKey) }
    }
    var isoSpeed: Double? {
        get { item.value(forAttribute: NSMetadataItemISOSpeedKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemISOSpeedKey) }
    }
    var orientation: Double? {
        get { item.value(forAttribute: NSMetadataItemOrientationKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemOrientationKey) }
    }
    var layerNames: [String]? {
        get { item.value(forAttribute: NSMetadataItemLayerNamesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemLayerNamesKey) }
    }
    var whiteBalance: Double? {
        get { item.value(forAttribute: NSMetadataItemWhiteBalanceKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemWhiteBalanceKey) }
    }
    var aperture: Double? {
        get { item.value(forAttribute: NSMetadataItemApertureKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemApertureKey) }
    }
    var profileName: String? {
        get { item.value(forAttribute: NSMetadataItemProfileNameKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemProfileNameKey) }
    }
    var resolutionWidthDpi: Double? {
        get { item.value(forAttribute: NSMetadataItemResolutionWidthDPIKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemResolutionWidthDPIKey) }
    }
    var resolutionHeightDpi: Double? {
        get { item.value(forAttribute: NSMetadataItemResolutionHeightDPIKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemResolutionHeightDPIKey) }
    }
    var exposureMode: Double? {
        get { item.value(forAttribute: NSMetadataItemExposureModeKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemExposureModeKey) }
    }
    var exposureTimeSeconds: Double? {
        get { item.value(forAttribute: NSMetadataItemExposureTimeSecondsKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemExposureTimeSecondsKey) }
    }
    var exifVersion: String? {
        get { item.value(forAttribute: NSMetadataItemEXIFVersionKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemEXIFVersionKey) }
    }
    var cameraOwner: String? {
        get { item.value(forAttribute: NSMetadataItemCameraOwnerKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemCameraOwnerKey) }
    }
    var focalLength35Mm: Double? {
        get { item.value(forAttribute: NSMetadataItemFocalLength35mmKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemFocalLength35mmKey) }
    }
    var lensModel: String? {
        get { item.value(forAttribute: NSMetadataItemLensModelKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemLensModelKey) }
    }
    var exifgpsVersion: String? {
        get { item.value(forAttribute: NSMetadataItemEXIFGPSVersionKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemEXIFGPSVersionKey) }
    }
    var altitude: Double? {
        get { item.value(forAttribute: NSMetadataItemAltitudeKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemAltitudeKey) }
    }
    var latitude: Double? {
        get { item.value(forAttribute: NSMetadataItemLatitudeKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemLatitudeKey) }
    }
    var longitude: Double? {
        get { item.value(forAttribute: NSMetadataItemLongitudeKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemLongitudeKey) }
    }
    var speed: Double? {
        get { item.value(forAttribute: NSMetadataItemSpeedKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemSpeedKey) }
    }
    var timestamp: Date? {
        get { item.value(forAttribute: NSMetadataItemTimestampKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemTimestampKey) }
    }
    var gpsTrack: Double? {
        get { item.value(forAttribute: NSMetadataItemGPSTrackKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSTrackKey) }
    }
    var imageDirection: Double? {
        get { item.value(forAttribute: NSMetadataItemImageDirectionKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemImageDirectionKey) }
    }
    var namedLocation: String? {
        get { item.value(forAttribute: NSMetadataItemNamedLocationKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemNamedLocationKey) }
    }
    var gpsStatus: String? {
        get { item.value(forAttribute: NSMetadataItemGPSStatusKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSStatusKey) }
    }
    var gpsMeasureMode: String? {
        get { item.value(forAttribute: NSMetadataItemGPSMeasureModeKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSMeasureModeKey) }
    }
    var gpsdop: Double? {
        get { item.value(forAttribute: NSMetadataItemGPSDOPKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSDOPKey) }
    }
    var gpsMapDatum: String? {
        get { item.value(forAttribute: NSMetadataItemGPSMapDatumKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSMapDatumKey) }
    }
    var gpsDestLatitude: Double? {
        get { item.value(forAttribute: NSMetadataItemGPSDestLatitudeKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSDestLatitudeKey) }
    }
    var gpsDestLongitude: Double? {
        get { item.value(forAttribute: NSMetadataItemGPSDestLongitudeKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSDestLongitudeKey) }
    }
    var gpsDestBearing: Double? {
        get { item.value(forAttribute: NSMetadataItemGPSDestBearingKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSDestBearingKey) }
    }
    var gpsDestDistance: Double? {
        get { item.value(forAttribute: NSMetadataItemGPSDestDistanceKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSDestDistanceKey) }
    }
    var gpsProcessingMethod: String? {
        get { item.value(forAttribute: NSMetadataItemGPSProcessingMethodKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSProcessingMethodKey) }
    }
    var gpsAreaInformation: String? {
        get { item.value(forAttribute: NSMetadataItemGPSAreaInformationKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSAreaInformationKey) }
    }
    var gpsDateStamp: Date? {
        get { item.value(forAttribute: NSMetadataItemGPSDateStampKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSDateStampKey) }
    }
    var gpsDifferental: Double? {
        get { item.value(forAttribute: NSMetadataItemGPSDifferentalKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemGPSDifferentalKey) }
    }
    var codecs: [String]? {
        get { item.value(forAttribute: NSMetadataItemCodecsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemCodecsKey) }
    }
    var mediaTypes: [String]? {
        get { item.value(forAttribute: NSMetadataItemMediaTypesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemMediaTypesKey) }
    }
    var streamable: Bool? {
        get { item.value(forAttribute: NSMetadataItemStreamableKey) as? Bool }
        // set { item.setValue(newValue, forKey: NSMetadataItemStreamableKey) }
    }
    var totalBitRate: Double? {
        get { item.value(forAttribute: NSMetadataItemTotalBitRateKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemTotalBitRateKey) }
    }
    var videoBitRate: Double? {
        get { item.value(forAttribute: NSMetadataItemVideoBitRateKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemVideoBitRateKey) }
    }
    var audioBitRate: Double? {
        get { item.value(forAttribute: NSMetadataItemAudioBitRateKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemAudioBitRateKey) }
    }
    var deliveryType: String? {
        get { item.value(forAttribute: NSMetadataItemDeliveryTypeKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemDeliveryTypeKey) }
    }
    var album: String? {
        get { item.value(forAttribute: NSMetadataItemAlbumKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemAlbumKey) }
    }
    var hasAlphaChannel: Bool? {
        get { item.value(forAttribute: NSMetadataItemHasAlphaChannelKey) as? Bool }
        // set { item.setValue(newValue, forKey: NSMetadataItemHasAlphaChannelKey) }
    }
    var redEyeOnOff: Bool? {
        get { item.value(forAttribute: NSMetadataItemRedEyeOnOffKey) as? Bool }
        // set { item.setValue(newValue, forKey: NSMetadataItemRedEyeOnOffKey) }
    }
    var meteringMode: String? {
        get { item.value(forAttribute: NSMetadataItemMeteringModeKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemMeteringModeKey) }
    }
    var maxAperture: Double? {
        get { item.value(forAttribute: NSMetadataItemMaxApertureKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemMaxApertureKey) }
    }
    var fNumber: Double? {
        get { item.value(forAttribute: NSMetadataItemFNumberKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemFNumberKey) }
    }
    var exposureProgram: String? {
        get { item.value(forAttribute: NSMetadataItemExposureProgramKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemExposureProgramKey) }
    }
    var exposureTimeString: String? {
        get { item.value(forAttribute: NSMetadataItemExposureTimeStringKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemExposureTimeStringKey) }
    }
    var headline: String? {
        get { item.value(forAttribute: NSMetadataItemHeadlineKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemHeadlineKey) }
    }
    var instructions: String? {
        get { item.value(forAttribute: NSMetadataItemInstructionsKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemInstructionsKey) }
    }
    var city: String? {
        get { item.value(forAttribute: NSMetadataItemCityKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemCityKey) }
    }
    var stateOrProvince: String? {
        get { item.value(forAttribute: NSMetadataItemStateOrProvinceKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemStateOrProvinceKey) }
    }
    var country: String? {
        get { item.value(forAttribute: NSMetadataItemCountryKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemCountryKey) }
    }
    var textContent: String? {
        get { item.value(forAttribute: NSMetadataItemTextContentKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemTextContentKey) }
    }
    var audioSampleRate: Double? {
        get { item.value(forAttribute: NSMetadataItemAudioSampleRateKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemAudioSampleRateKey) }
    }
    var audioChannelCount: Double? {
        get { item.value(forAttribute: NSMetadataItemAudioChannelCountKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemAudioChannelCountKey) }
    }
    var tempo: Double? {
        get { item.value(forAttribute: NSMetadataItemTempoKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemTempoKey) }
    }
    var keySignature: String? {
        get { item.value(forAttribute: NSMetadataItemKeySignatureKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemKeySignatureKey) }
    }
    var timeSignature: String? {
        get { item.value(forAttribute: NSMetadataItemTimeSignatureKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemTimeSignatureKey) }
    }
    var audioEncodingApplication: String? {
        get { item.value(forAttribute: NSMetadataItemAudioEncodingApplicationKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemAudioEncodingApplicationKey) }
    }
    var composer: String? {
        get { item.value(forAttribute: NSMetadataItemComposerKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemComposerKey) }
    }
    var lyricist: String? {
        get { item.value(forAttribute: NSMetadataItemLyricistKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemLyricistKey) }
    }
    var audioTrackNumber: Double? {
        get { item.value(forAttribute: NSMetadataItemAudioTrackNumberKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemAudioTrackNumberKey) }
    }
    var recordingDate: Date? {
        get { item.value(forAttribute: NSMetadataItemRecordingDateKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemRecordingDateKey) }
    }
    var musicalGenre: String? {
        get { item.value(forAttribute: NSMetadataItemMusicalGenreKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemMusicalGenreKey) }
    }
    var isGeneralMidiSequence: Bool? {
        get { item.value(forAttribute: NSMetadataItemIsGeneralMIDISequenceKey) as? Bool }
        // set { item.setValue(newValue, forKey: NSMetadataItemIsGeneralMIDISequenceKey) }
    }
    var recordingYear: Double? {
        get { item.value(forAttribute: NSMetadataItemRecordingYearKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemRecordingYearKey) }
    }
    var organizations: [String]? {
        get { item.value(forAttribute: NSMetadataItemOrganizationsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemOrganizationsKey) }
    }
    var languages: [String]? {
        get { item.value(forAttribute: NSMetadataItemLanguagesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemLanguagesKey) }
    }
    var rights: String? {
        get { item.value(forAttribute: NSMetadataItemRightsKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemRightsKey) }
    }
    var publishers: [String]? {
        get { item.value(forAttribute: NSMetadataItemPublishersKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemPublishersKey) }
    }
    var contributors: [String]? {
        get { item.value(forAttribute: NSMetadataItemContributorsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemContributorsKey) }
    }
    var coverage: [String]? {
        get { item.value(forAttribute: NSMetadataItemCoverageKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemCoverageKey) }
    }
    var subject: String? {
        get { item.value(forAttribute: NSMetadataItemSubjectKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemSubjectKey) }
    }
    var theme: String? {
        get { item.value(forAttribute: NSMetadataItemThemeKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemThemeKey) }
    }
    var description: String? {
        get { item.value(forAttribute: NSMetadataItemDescriptionKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemDescriptionKey) }
    }
    var identifier: String? {
        get { item.value(forAttribute: NSMetadataItemIdentifierKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemIdentifierKey) }
    }
    var audiences: [String]? {
        get { item.value(forAttribute: NSMetadataItemAudiencesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemAudiencesKey) }
    }
    var numberOfPages: Double? {
        get { item.value(forAttribute: NSMetadataItemNumberOfPagesKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemNumberOfPagesKey) }
    }
    var pageWidth: Double? {
        get { item.value(forAttribute: NSMetadataItemPageWidthKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemPageWidthKey) }
    }
    var pageHeight: Double? {
        get { item.value(forAttribute: NSMetadataItemPageHeightKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemPageHeightKey) }
    }
    var securityMethod: Double? {
        get { item.value(forAttribute: NSMetadataItemSecurityMethodKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemSecurityMethodKey) }
    }
    var creator: String? {
        get { item.value(forAttribute: NSMetadataItemCreatorKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemCreatorKey) }
    }
    var encodingApplications: [String]? {
        get { item.value(forAttribute: NSMetadataItemEncodingApplicationsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemEncodingApplicationsKey) }
    }
    var dueDate: Date? {
        get { item.value(forAttribute: NSMetadataItemDueDateKey) as? Date }
        // set { item.setValue(newValue, forKey: NSMetadataItemDueDateKey) }
    }
    var starRating: Double? {
        get { item.value(forAttribute: NSMetadataItemStarRatingKey) as? Double }
        // set { item.setValue(newValue, forKey: NSMetadataItemStarRatingKey) }
    }
    var phoneNumbers: [String]? {
        get { item.value(forAttribute: NSMetadataItemPhoneNumbersKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemPhoneNumbersKey) }
    }
    var emailAddresses: [String]? {
        get { item.value(forAttribute: NSMetadataItemEmailAddressesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemEmailAddressesKey) }
    }
    var instantMessageAddresses: [String]? {
        get { item.value(forAttribute: NSMetadataItemInstantMessageAddressesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemInstantMessageAddressesKey) }
    }
    var kind: [String]? {
        get { item.value(forAttribute: NSMetadataItemKindKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemKindKey) }
    }
    var recipients: [String]? {
        get { item.value(forAttribute: NSMetadataItemRecipientsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemRecipientsKey) }
    }
    var finderComment: String? {
        get { item.value(forAttribute: NSMetadataItemFinderCommentKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemFinderCommentKey) }
    }
    var fonts: [String]? {
        get { item.value(forAttribute: NSMetadataItemFontsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemFontsKey) }
    }
    var appleLoopsRootKey: String? {
        get { item.value(forAttribute: NSMetadataItemAppleLoopsRootKeyKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemAppleLoopsRootKeyKey) }
    }
    var appleLoopsKeyFilterType: String? {
        get { item.value(forAttribute: NSMetadataItemAppleLoopsKeyFilterTypeKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemAppleLoopsKeyFilterTypeKey) }
    }
    var appleLoopsLoopMode: String? {
        get { item.value(forAttribute: NSMetadataItemAppleLoopsLoopModeKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemAppleLoopsLoopModeKey) }
    }
    var appleLoopDescriptors: [String]? {
        get { item.value(forAttribute: NSMetadataItemAppleLoopDescriptorsKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemAppleLoopDescriptorsKey) }
    }
    var musicalInstrumentCategory: String? {
        get { item.value(forAttribute: NSMetadataItemMusicalInstrumentCategoryKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemMusicalInstrumentCategoryKey) }
    }
    var musicalInstrumentName: String? {
        get { item.value(forAttribute: NSMetadataItemMusicalInstrumentNameKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemMusicalInstrumentNameKey) }
    }
    var cfBundleIdentifier: String? {
        get { item.value(forAttribute: NSMetadataItemCFBundleIdentifierKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemCFBundleIdentifierKey) }
    }
    var information: String? {
        get { item.value(forAttribute: NSMetadataItemInformationKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemInformationKey) }
    }
    var director: String? {
        get { item.value(forAttribute: NSMetadataItemDirectorKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemDirectorKey) }
    }
    var producer: String? {
        get { item.value(forAttribute: NSMetadataItemProducerKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemProducerKey) }
    }
    var genre: String? {
        get { item.value(forAttribute: NSMetadataItemGenreKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemGenreKey) }
    }
    var performers: [String]? {
        get { item.value(forAttribute: NSMetadataItemPerformersKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemPerformersKey) }
    }
    var originalFormat: String? {
        get { item.value(forAttribute: NSMetadataItemOriginalFormatKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemOriginalFormatKey) }
    }
    var originalSource: String? {
        get { item.value(forAttribute: NSMetadataItemOriginalSourceKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemOriginalSourceKey) }
    }
    var authorEmailAddresses: [String]? {
        get { item.value(forAttribute: NSMetadataItemAuthorEmailAddressesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemAuthorEmailAddressesKey) }
    }
    var recipientEmailAddresses: [String]? {
        get { item.value(forAttribute: NSMetadataItemRecipientEmailAddressesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemRecipientEmailAddressesKey) }
    }
    var authorAddresses: [String]? {
        get { item.value(forAttribute: NSMetadataItemAuthorAddressesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemAuthorAddressesKey) }
    }
    var recipientAddresses: [String]? {
        get { item.value(forAttribute: NSMetadataItemRecipientAddressesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemRecipientAddressesKey) }
    }
    var isLikelyJunk: Bool? {
        get { item.value(forAttribute: NSMetadataItemIsLikelyJunkKey) as? Bool }
        // set { item.setValue(newValue, forKey: NSMetadataItemIsLikelyJunkKey) }
    }
    var executableArchitectures: [String]? {
        get { item.value(forAttribute: NSMetadataItemExecutableArchitecturesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemExecutableArchitecturesKey) }
    }
    var executablePlatform: String? {
        get { item.value(forAttribute: NSMetadataItemExecutablePlatformKey) as? String }
        // set { item.setValue(newValue, forKey: NSMetadataItemExecutablePlatformKey) }
    }
    var applicationCategories: [String]? {
        get { item.value(forAttribute: NSMetadataItemApplicationCategoriesKey) as? [String] }
        // set { item.setValue(newValue, forKey: NSMetadataItemApplicationCategoriesKey) }
    }
    var isApplicationManaged: Bool? {
        get { item.value(forAttribute: NSMetadataItemIsApplicationManagedKey) as? Bool }
        // set { item.setValue(newValue, forKey: NSMetadataItemIsApplicationManagedKey) }
    }
        
    var isScreenCapture: Bool? {
        get { item.value(forAttribute: "kMDItemIsScreenCapture") as? Bool }
        // set { item.setValue(newValue, forKey: "kMDItemIsScreenCapture") }
    }
    var queryResultContentRelevance: Float? {
        get { return nil }
        // set { item.setValue(newValue, forKey: "kMDItemIsScreenCapture") }
    }
}

extension URLMetadata {
    var dataSize: DataSize? {
        if let fsSize = fsSize {
            return DataSize(fsSize)
        }
        return nil
    }
}

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
extension URLMetadata {
    @available(macOS 11.0, iOS 14.0, *)
    var contentUTType: UTType? {
        get { if let string = item.value(forAttribute: NSMetadataItemContentTypeKey) as? String
            {
            return UTType(string)
        } else {
            return nil
        }
        }
    }
}
#endif
