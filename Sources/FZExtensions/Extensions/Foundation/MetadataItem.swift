import Foundation

public extension URL {
    var metadata: MetadataItem? {
        return MetadataItem(url: self)  }
}

public class MetadataItem {
    internal let item: NSMetadataItem
    internal let values: [String:Any]

    public init?(url: URL, values: [String:Any]? = nil) {
        if let item = NSMetadataItem(url: url) {
            self.item = item
            self.values = values ?? [:]
        } else {
            return nil
        }
    }
    
    public init(item: NSMetadataItem, values: [String:Any]? = nil) {
            self.item = item
            self.values = values ?? [:]
    }
        
    public var attributes: [String] {
        var attributes = item.attributes
        attributes.append(contentsOf: values.keys)
        return attributes
    }
    
    public var url: URL? {
        get { self.value( NSMetadataItemURLKey, type: URL.self) } }
       
    public var fsName: String? {
        get { self.value( NSMetadataItemFSNameKey, type: String.self) } }
    
    public var displayName: String? {
        get { self.value( NSMetadataItemDisplayNameKey, type: String.self) } }
    
    public var path: String? {
        get { self.value( NSMetadataItemPathKey, type: String.self) } }
    
    public var fsSize: Int? {
        get { self.value( NSMetadataItemFSSizeKey, type: Int.self) } }
        
    public var fsCreationDate: Date? {
        get { self.value( NSMetadataItemFSCreationDateKey, type: Date.self) } }
    
    public var fsContentChangeDate: Date? {
        get { self.value( NSMetadataItemFSContentChangeDateKey, type: Date.self) } }
    
    public var contentType: String? {
        get { self.value( NSMetadataItemContentTypeKey, type: String.self) } }
    
    public var contentTypeTree: [String]? {
        get { self.value( NSMetadataItemContentTypeTreeKey, type: [String].self) } }
    
    public var attributeChangeDate: Date? {
        get { self.value( NSMetadataItemAttributeChangeDateKey, type: Date.self) } }
    
    public var keywords: [String]? {
        get { self.value( NSMetadataItemKeywordsKey, type: [String].self) } }
    
    public var title: String? {
        get { self.value( NSMetadataItemTitleKey, type: String.self) } }
    
    public var authors: [String]? {
        get { self.value( NSMetadataItemAuthorsKey, type: [String].self) } }
    
    public var editors: [String]? {
        get { self.value( NSMetadataItemEditorsKey, type: [String].self) } }
    
    public var participants: [String]? {
        get { self.value( NSMetadataItemParticipantsKey, type: [String].self) } }
    
    public var projects: [String]? {
        get { self.value( NSMetadataItemProjectsKey, type: [String].self) } }
    
    public var downloadedDate: Date? {
        get { self.value( NSMetadataItemDownloadedDateKey, type: Date.self) } }
    
    public var whereFroms: [String]? {
        get { self.value( NSMetadataItemWhereFromsKey, type: [String].self) } }
    
    public var comment: String? {
        get { self.value( NSMetadataItemCommentKey, type: String.self) } }
    
    public var copyright: String? {
        get { self.value( NSMetadataItemCopyrightKey, type: String.self) } }
    
    public var lastUsedDate: Date? {
        get { self.value( NSMetadataItemLastUsedDateKey, type: Date.self) } }
        
    public var contentCreationDate: Date? {
        get { self.value( NSMetadataItemContentCreationDateKey, type: Date.self) } }
        
    public var contentModificationDate: Date? {
        get { self.value( NSMetadataItemContentModificationDateKey, type: Date.self) } }
        
    public var dateAdded: Date? {
        get { self.value( NSMetadataItemDateAddedKey, type: Date.self) } }
        
    public var durationSeconds: Double? {
        get { self.value( NSMetadataItemDurationSecondsKey, type: Double.self) } }
        
    public var contactKeywords: [String]? {
        get { self.value( NSMetadataItemContactKeywordsKey, type: [String].self) } }
        
    public var version: String? {
        get { self.value( NSMetadataItemVersionKey, type: String.self) } }
        
    public var pixelHeight: Double? {
        get { self.value( NSMetadataItemPixelHeightKey, type: Double.self) } }
        
    public var pixelWidth: Double? {
        get { self.value( NSMetadataItemPixelWidthKey, type: Double.self) } }
        
    public var pixelSize: CGSize? {
        get {
            if let height = self.value(NSMetadataItemPixelHeightKey, type: Double.self), let width = self.value(NSMetadataItemPixelWidthKey,type: Double.self) {
                return CGSize(width: width, height: height) }
                return nil } }
    
    public var pixelCount: Double? {
        get { self.value( NSMetadataItemPixelCountKey, type: Double.self) } }
        
    public var colorSpace: String? {
        get { self.value( NSMetadataItemColorSpaceKey, type: String.self) } }
        
    public var bitsPerSample: Double? {
        get { self.value( NSMetadataItemBitsPerSampleKey, type: Double.self) } }
        
    public var flashOnOff: Bool? {
        get { self.value( NSMetadataItemFlashOnOffKey, type: Bool.self) } }
        
    public var focalLength: Double? {
        get { self.value( NSMetadataItemFocalLengthKey, type: Double.self) } }
        
    public var acquisitionMake: String? {
        get { self.value( NSMetadataItemAcquisitionMakeKey, type: String.self) } }
        
    public var acquisitionModel: String? {
        get { self.value( NSMetadataItemAcquisitionModelKey, type: String.self) } }
        
    public var isoSpeed: Double? {
        get { self.value( NSMetadataItemISOSpeedKey, type: Double.self) } }
        
    public var orientation: Double? {
        get { self.value( NSMetadataItemOrientationKey, type: Double.self) } }
        
    public var layerNames: [String]? {
        get { self.value( NSMetadataItemLayerNamesKey, type: [String].self) } }
        
    public var whiteBalance: Double? {
        get { self.value( NSMetadataItemWhiteBalanceKey, type: Double.self) } }
        
    public var aperture: Double? {
        get { self.value( NSMetadataItemApertureKey, type: Double.self) } }
        
    public var profileName: String? {
        get { self.value( NSMetadataItemProfileNameKey, type: String.self) } }
        
    public var resolutionWidthDpi: Double? {
        get { self.value( NSMetadataItemResolutionWidthDPIKey, type: Double.self) } }
        
    public var resolutionHeightDpi: Double? {
        get { self.value( NSMetadataItemResolutionHeightDPIKey, type: Double.self) } }
        
    public var exposureMode: Double? {
        get { self.value( NSMetadataItemExposureModeKey, type: Double.self) } }
        
    public var exposureTimeSeconds: Double? {
        get { self.value( NSMetadataItemExposureTimeSecondsKey, type: Double.self) } }
        
    public var exifVersion: String? {
        get { self.value( NSMetadataItemEXIFVersionKey, type: String.self) } }
        
    public var cameraOwner: String? {
        get { self.value( NSMetadataItemCameraOwnerKey, type: String.self) } }
        
    public var focalLength35Mm: Double? {
        get { self.value( NSMetadataItemFocalLength35mmKey, type: Double.self) } }
        
    public var lensModel: String? {
        get { self.value( NSMetadataItemLensModelKey, type: String.self) } }
        
    public var exifgpsVersion: String? {
        get { self.value( NSMetadataItemEXIFGPSVersionKey, type: String.self) } }
        
    public var altitude: Double? {
        get { self.value( NSMetadataItemAltitudeKey, type: Double.self) } }
        
    public var latitude: Double? {
        get { self.value( NSMetadataItemLatitudeKey, type: Double.self) } }
        
    public var longitude: Double? {
        get { self.value( NSMetadataItemLongitudeKey, type: Double.self) } }
        
    public var speed: Double? {
        get { self.value( NSMetadataItemSpeedKey, type: Double.self) } }
        
    public var timestamp: Date? {
        get { self.value( NSMetadataItemTimestampKey, type: Date.self) } }
        
    public var gpsTrack: Double? {
        get { self.value( NSMetadataItemGPSTrackKey, type: Double.self) } }
        
    public var imageDirection: Double? {
        get { self.value( NSMetadataItemImageDirectionKey, type: Double.self) } }
        
    public var namedLocation: String? {
        get { self.value( NSMetadataItemNamedLocationKey, type: String.self) } }
        
    public var gpsStatus: String? {
        get { self.value( NSMetadataItemGPSStatusKey, type: String.self) } }
        
    public var gpsMeasureMode: String? {
        get { self.value( NSMetadataItemGPSMeasureModeKey, type: String.self) } }
        
    public var gpsdop: Double? {
        get { self.value( NSMetadataItemGPSDOPKey, type: Double.self) } }
        
    public var gpsMapDatum: String? {
        get { self.value( NSMetadataItemGPSMapDatumKey, type: String.self) } }
        
    public var gpsDestLatitude: Double? {
        get { self.value( NSMetadataItemGPSDestLatitudeKey, type: Double.self) } }
        
    public var gpsDestLongitude: Double? {
        get { self.value( NSMetadataItemGPSDestLongitudeKey, type: Double.self) } }
        
    public var gpsDestBearing: Double? {
        get { self.value( NSMetadataItemGPSDestBearingKey, type: Double.self) } }
        
    public var gpsDestDistance: Double? {
        get { self.value( NSMetadataItemGPSDestDistanceKey, type: Double.self) } }
        
    public var gpsProcessingMethod: String? {
        get { self.value( NSMetadataItemGPSProcessingMethodKey, type: String.self) } }
        
    public var gpsAreaInformation: String? {
        get { self.value( NSMetadataItemGPSAreaInformationKey, type: String.self) } }
        
    public var gpsDateStamp: Date? {
        get { self.value( NSMetadataItemGPSDateStampKey, type: Date.self) } }
        
    public var gpsDifferental: Double? {
        get { self.value( NSMetadataItemGPSDifferentalKey, type: Double.self) } }
        
    public var codecs: [String]? {
        get { self.value( NSMetadataItemCodecsKey, type: [String].self) } }
        
    public var mediaTypes: [String]? {
        get { self.value( NSMetadataItemMediaTypesKey, type: [String].self) } }
        
    public var streamable: Bool? {
        get { self.value( NSMetadataItemStreamableKey, type: Bool.self) } }
        
    public var totalBitRate: Double? {
        get { self.value( NSMetadataItemTotalBitRateKey, type: Double.self) } }
        
    public var videoBitRate: Double? {
        get { self.value( NSMetadataItemVideoBitRateKey, type: Double.self) } }
        
    public var audioBitRate: Double? {
        get { self.value( NSMetadataItemAudioBitRateKey, type: Double.self) } }
        
    public var deliveryType: String? {
        get { self.value( NSMetadataItemDeliveryTypeKey, type: String.self) } }
        
    public var album: String? {
        get { self.value( NSMetadataItemAlbumKey, type: String.self) } }
        
    public var hasAlphaChannel: Bool? {
        get { self.value( NSMetadataItemHasAlphaChannelKey, type: Bool.self) } }
        
    public var redEyeOnOff: Bool? {
        get { self.value( NSMetadataItemRedEyeOnOffKey, type: Bool.self) } }
        
    public var meteringMode: String? {
        get { self.value( NSMetadataItemMeteringModeKey, type: String.self) } }
        
    public var maxAperture: Double? {
        get { self.value( NSMetadataItemMaxApertureKey, type: Double.self) } }
        
    public var fNumber: Double? {
        get { self.value( NSMetadataItemFNumberKey, type: Double.self) } }
        
    public var exposureProgram: String? {
        get { self.value( NSMetadataItemExposureProgramKey, type: String.self) } }
        
    public var exposureTimeString: String? {
        get { self.value( NSMetadataItemExposureTimeStringKey, type: String.self) } }
        
    public var headline: String? {
        get { self.value( NSMetadataItemHeadlineKey, type: String.self) } }
        
    public var instructions: String? {
        get { self.value( NSMetadataItemInstructionsKey, type: String.self) } }
        
    public var city: String? {
        get { self.value( NSMetadataItemCityKey, type: String.self) } }
        
    public var stateOrProvince: String? {
        get { self.value( NSMetadataItemStateOrProvinceKey, type: String.self) } }
        
    public var country: String? {
        get { self.value( NSMetadataItemCountryKey, type: String.self) } }
        
    public var textContent: String? {
        get { self.value( NSMetadataItemTextContentKey, type: String.self) } }
        
    public var audioSampleRate: Double? {
        get { self.value( NSMetadataItemAudioSampleRateKey, type: Double.self) } }
        
    public var audioChannelCount: Double? {
        get { self.value( NSMetadataItemAudioChannelCountKey, type: Double.self) } }
        
    public var tempo: Double? {
        get { self.value( NSMetadataItemTempoKey, type: Double.self) } }
        
    public var keySignature: String? {
        get { self.value( NSMetadataItemKeySignatureKey, type: String.self) } }
        
    public var timeSignature: String? {
        get { self.value( NSMetadataItemTimeSignatureKey, type: String.self) } }
        
    public var audioEncodingApplication: String? {
        get { self.value( NSMetadataItemAudioEncodingApplicationKey, type: String.self) } }
        
    public var composer: String? {
        get { self.value( NSMetadataItemComposerKey, type: String.self) } }
        
    public var lyricist: String? {
        get { self.value( NSMetadataItemLyricistKey, type: String.self) } }
        
    public var audioTrackNumber: Double? {
        get { self.value( NSMetadataItemAudioTrackNumberKey, type: Double.self) } }
        
    public var recordingDate: Date? {
        get { self.value( NSMetadataItemRecordingDateKey, type: Date.self) } }
        
    public var musicalGenre: String? {
        get { self.value( NSMetadataItemMusicalGenreKey, type: String.self) } }
        
    public var isGeneralMidiSequence: Bool? {
        get { self.value( NSMetadataItemIsGeneralMIDISequenceKey, type: Bool.self) } }
        
    public var recordingYear: Double? {
        get { self.value( NSMetadataItemRecordingYearKey, type: Double.self) } }
        
    public var organizations: [String]? {
        get { self.value( NSMetadataItemOrganizationsKey, type: [String].self) } }
        
    public var languages: [String]? {
        get { self.value( NSMetadataItemLanguagesKey, type: [String].self) } }
        
    public var rights: String? {
        get { self.value( NSMetadataItemRightsKey, type: String.self) } }
        
    public var publishers: [String]? {
        get { self.value( NSMetadataItemPublishersKey, type: [String].self) } }
        
    public var contributors: [String]? {
        get { self.value( NSMetadataItemContributorsKey, type: [String].self) } }
        
    public var coverage: [String]? {
        get { self.value( NSMetadataItemCoverageKey, type: [String].self) } }
        
    public var subject: String? {
        get { self.value( NSMetadataItemSubjectKey, type: String.self) } }
        
    public var theme: String? {
        get { self.value( NSMetadataItemThemeKey, type: String.self) } }
        
    public var description: String? {
        get { self.value( NSMetadataItemDescriptionKey, type: String.self) } }
        
    public var identifier: String? {
        get { self.value( NSMetadataItemIdentifierKey, type: String.self) } }
        
    public var audiences: [String]? {
        get { self.value( NSMetadataItemAudiencesKey, type: [String].self) } }
        
    public var numberOfPages: Double? {
        get { self.value( NSMetadataItemNumberOfPagesKey, type: Double.self) } }
        
    public var pageWidth: Double? {
        get { self.value( NSMetadataItemPageWidthKey, type: Double.self) } }
        
    public var pageHeight: Double? {
        get { self.value( NSMetadataItemPageHeightKey, type: Double.self) } }
        
    public var securityMethod: Double? {
        get { self.value( NSMetadataItemSecurityMethodKey, type: Double.self) } }
        
    public var creator: String? {
        get { self.value( NSMetadataItemCreatorKey, type: String.self) } }
        
    public var encodingApplications: [String]? {
        get { self.value( NSMetadataItemEncodingApplicationsKey, type: [String].self) } }
        
    public var dueDate: Date? {
        get { self.value( NSMetadataItemDueDateKey, type: Date.self) } }
        
    public var starRating: Double? {
        get { self.value( NSMetadataItemStarRatingKey, type: Double.self) } }
        
    public var phoneNumbers: [String]? {
        get { self.value( NSMetadataItemPhoneNumbersKey, type: [String].self) } }
        
    public var emailAddresses: [String]? {
        get { self.value( NSMetadataItemEmailAddressesKey, type: [String].self) } }
        
    public var instantMessageAddresses: [String]? {
        get { self.value( NSMetadataItemInstantMessageAddressesKey, type: [String].self) } }
        
    public var kind: [String]? {
        get { self.value( NSMetadataItemKindKey, type: [String].self) } }
        
    public var recipients: [String]? {
        get { self.value( NSMetadataItemRecipientsKey, type: [String].self) } }
        
    public var finderComment: String? {
        get { self.value( NSMetadataItemFinderCommentKey, type: String.self) } }
        
    public var fonts: [String]? {
        get { self.value( NSMetadataItemFontsKey, type: [String].self) } }
        
    public var appleLoopsRootKey: String? {
        get { self.value( NSMetadataItemAppleLoopsRootKeyKey, type: String.self) } }
        
    public var appleLoopsKeyFilterType: String? {
        get { self.value( NSMetadataItemAppleLoopsKeyFilterTypeKey, type: String.self) } }
        
    public var appleLoopsLoopMode: String? {
        get { self.value( NSMetadataItemAppleLoopsLoopModeKey, type: String.self) } }
        
    public var appleLoopDescriptors: [String]? {
        get { self.value( NSMetadataItemAppleLoopDescriptorsKey, type: [String].self) } }
        
    public var musicalInstrumentCategory: String? {
        get { self.value( NSMetadataItemMusicalInstrumentCategoryKey, type: String.self) } }
        
    public var musicalInstrumentName: String? {
        get { self.value( NSMetadataItemMusicalInstrumentNameKey, type: String.self) } }

    public var cfBundleIdentifier: String? {
        get { self.value( NSMetadataItemCFBundleIdentifierKey, type: String.self) } }

    public var information: String? {
        get { self.value( NSMetadataItemInformationKey, type: String.self) } }

    public var director: String? {
        get { self.value( NSMetadataItemDirectorKey, type: String.self) } }

    public var producer: String? {
        get { self.value( NSMetadataItemProducerKey, type: String.self) } }

    public var genre: String? {
        get { self.value( NSMetadataItemGenreKey, type: String.self) } }

    public var performers: [String]? {
        get { self.value( NSMetadataItemPerformersKey, type: [String].self) } }

    public var originalFormat: String? {
        get { self.value(NSMetadataItemOriginalFormatKey, type: String.self) } }

    public var originalSource: String? {
        get { self.value(NSMetadataItemOriginalSourceKey, type: String.self) } }

    public var authorEmailAddresses: [String]? {
        get { self.value( NSMetadataItemAuthorEmailAddressesKey, type: [String].self) } }

    public var recipientEmailAddresses: [String]? {
        get { self.value( NSMetadataItemRecipientEmailAddressesKey, type: [String].self) } }

    public var authorAddresses: [String]? {
        get { self.value( NSMetadataItemAuthorAddressesKey, type: [String].self) } }

    public var recipientAddresses: [String]? {
        get { self.value( NSMetadataItemRecipientAddressesKey, type: [String].self) } }

    public var isLikelyJunk: Bool? {
        get { self.value( NSMetadataItemIsLikelyJunkKey, type: Bool.self) } }

    public var executableArchitectures: [String]? {
        get { self.value( NSMetadataItemExecutableArchitecturesKey, type: [String].self) } }

    public var executablePlatform: String? {
        get { self.value(NSMetadataItemExecutablePlatformKey, type: String.self) } }

    public var applicationCategories: [String]? {
        get { self.value( NSMetadataItemApplicationCategoriesKey, type: [String].self) } }

    public var isApplicationManaged: Bool? {
        get { self.value(NSMetadataItemIsApplicationManagedKey, type: Bool.self) } }
        
    public var isScreenCapture: Bool {
        get { self.value("kMDItemIsScreenCapture", type: Bool.self) ?? false }  }
    
    public var queryResultContentRelevance: Float? {
        get { return nil } }
        
    internal func value<T>(_ attribute: String, type: T.Type) -> T? {
        if let value = self.values[attribute] as? T {
            return value }
        return item.value(attribute, type: type) }
}

public extension MetadataItem {
    var dataSize: DataSize? {
        if let fsSize = fsSize {
            return DataSize(fsSize)
        }
        return nil
    }
}

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
public extension MetadataItem {
    @available(macOS 11.0, iOS 14.0, *)
    var contentUTType: UTType? {
        get { if let string = item.value(forAttribute: NSMetadataItemContentTypeKey) as? String
            { return UTType(string) } else {
            return nil } }}
}
#endif
