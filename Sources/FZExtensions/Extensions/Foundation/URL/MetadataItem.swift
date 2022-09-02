import Foundation

public extension URL {
    var metadata: MetadataItem? {
        return MetadataItem(url: self)  }
}

public class MetadataItem {
    internal let item: NSMetadataItem
    internal let values: [String:Any]
    
    public init?(url: URL) {
        if let item = NSMetadataItem(url: url) {
            self.item = item
            self.values = [:]
        } else {
            return nil
        }
    }
    
    public init(item: NSMetadataItem) {
            self.item = item
            self.values = [:]
    }
    
    internal init?(url: URL, values: [String:Any]? = nil) {
        if let item = NSMetadataItem(url: url) {
            self.item = item
            self.values = values ?? [:]
        } else {
            return nil
        }
    }
    
    internal init(item: NSMetadataItem, values: [String:Any]?) {
            self.item = item
            self.values = values ?? [:]
    }
    
    public var queryAttributes: [String] {
        return [String](values.keys)
    }
        
    public var attributes: [String] {
        return item.attributes + queryAttributes
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

@available(macOS 10.12, *)
public extension MetadataItem {
    var keywords: [String]? {
        get { self.value( NSMetadataItemKeywordsKey, type: [String].self) } }
    
    var title: String? {
        get { self.value( NSMetadataItemTitleKey, type: String.self) } }
    
    var authors: [String]? {
        get { self.value( NSMetadataItemAuthorsKey, type: [String].self) } }
    
    var editors: [String]? {
        get { self.value( NSMetadataItemEditorsKey, type: [String].self) } }
    
    var participants: [String]? {
        get { self.value( NSMetadataItemParticipantsKey, type: [String].self) } }
    
    var projects: [String]? {
        get { self.value( NSMetadataItemProjectsKey, type: [String].self) } }
    
    var downloadedDate: Date? {
        get { self.value( NSMetadataItemDownloadedDateKey, type: Date.self) } }
    
    var whereFroms: [String]? {
        get { self.value( NSMetadataItemWhereFromsKey, type: [String].self) } }
    
    var comment: String? {
        get { self.value( NSMetadataItemCommentKey, type: String.self) } }
    
    var copyright: String? {
        get { self.value( NSMetadataItemCopyrightKey, type: String.self) } }
    
    var lastUsedDate: Date? {
        get { self.value( NSMetadataItemLastUsedDateKey, type: Date.self) } }
        
    var contentCreationDate: Date? {
        get { self.value( NSMetadataItemContentCreationDateKey, type: Date.self) } }
        
    var contentModificationDate: Date? {
        get { self.value( NSMetadataItemContentModificationDateKey, type: Date.self) } }
        
    var dateAdded: Date? {
        get { self.value( NSMetadataItemDateAddedKey, type: Date.self) } }
        
    var durationSeconds: Double? {
        get { self.value( NSMetadataItemDurationSecondsKey, type: Double.self) } }
        
    var contactKeywords: [String]? {
        get { self.value( NSMetadataItemContactKeywordsKey, type: [String].self) } }
        
    var version: String? {
        get { self.value( NSMetadataItemVersionKey, type: String.self) } }
        
    var pixelHeight: Double? {
        get { self.value( NSMetadataItemPixelHeightKey, type: Double.self) } }
        
    var pixelWidth: Double? {
        get { self.value( NSMetadataItemPixelWidthKey, type: Double.self) } }
        
    var pixelSize: CGSize? {
        get {
            if let height = self.value(NSMetadataItemPixelHeightKey, type: Double.self), let width = self.value(NSMetadataItemPixelWidthKey,type: Double.self) {
                return CGSize(width: width, height: height) }
                return nil } }
    
    var pixelCount: Double? {
        get { self.value( NSMetadataItemPixelCountKey, type: Double.self) } }
        
    var colorSpace: String? {
        get { self.value( NSMetadataItemColorSpaceKey, type: String.self) } }
        
    var bitsPerSample: Double? {
        get { self.value( NSMetadataItemBitsPerSampleKey, type: Double.self) } }
        
    var flashOnOff: Bool? {
        get { self.value( NSMetadataItemFlashOnOffKey, type: Bool.self) } }
        
    var focalLength: Double? {
        get { self.value( NSMetadataItemFocalLengthKey, type: Double.self) } }
        
    var acquisitionMake: String? {
        get { self.value( NSMetadataItemAcquisitionMakeKey, type: String.self) } }
        
    var acquisitionModel: String? {
        get { self.value( NSMetadataItemAcquisitionModelKey, type: String.self) } }
        
    var isoSpeed: Double? {
        get { self.value( NSMetadataItemISOSpeedKey, type: Double.self) } }
        
    var orientation: Double? {
        get { self.value( NSMetadataItemOrientationKey, type: Double.self) } }
        
    var layerNames: [String]? {
        get { self.value( NSMetadataItemLayerNamesKey, type: [String].self) } }
        
    var whiteBalance: Double? {
        get { self.value( NSMetadataItemWhiteBalanceKey, type: Double.self) } }
        
    var aperture: Double? {
        get { self.value( NSMetadataItemApertureKey, type: Double.self) } }
        
    var profileName: String? {
        get { self.value( NSMetadataItemProfileNameKey, type: String.self) } }
        
    var resolutionWidthDpi: Double? {
        get { self.value( NSMetadataItemResolutionWidthDPIKey, type: Double.self) } }
        
    var resolutionHeightDpi: Double? {
        get { self.value( NSMetadataItemResolutionHeightDPIKey, type: Double.self) } }
        
    var exposureMode: Double? {
        get { self.value( NSMetadataItemExposureModeKey, type: Double.self) } }
        
    var exposureTimeSeconds: Double? {
        get { self.value( NSMetadataItemExposureTimeSecondsKey, type: Double.self) } }
        
    var exifVersion: String? {
        get { self.value( NSMetadataItemEXIFVersionKey, type: String.self) } }
        
    var cameraOwner: String? {
        get { self.value( NSMetadataItemCameraOwnerKey, type: String.self) } }
        
    var focalLength35Mm: Double? {
        get { self.value( NSMetadataItemFocalLength35mmKey, type: Double.self) } }
        
    var lensModel: String? {
        get { self.value( NSMetadataItemLensModelKey, type: String.self) } }
        
    var exifgpsVersion: String? {
        get { self.value( NSMetadataItemEXIFGPSVersionKey, type: String.self) } }
        
    var altitude: Double? {
        get { self.value( NSMetadataItemAltitudeKey, type: Double.self) } }
        
    var latitude: Double? {
        get { self.value( NSMetadataItemLatitudeKey, type: Double.self) } }
        
    var longitude: Double? {
        get { self.value( NSMetadataItemLongitudeKey, type: Double.self) } }
        
    var speed: Double? {
        get { self.value( NSMetadataItemSpeedKey, type: Double.self) } }
        
    var timestamp: Date? {
        get { self.value( NSMetadataItemTimestampKey, type: Date.self) } }
        
    var gpsTrack: Double? {
        get { self.value( NSMetadataItemGPSTrackKey, type: Double.self) } }
        
    var imageDirection: Double? {
        get { self.value( NSMetadataItemImageDirectionKey, type: Double.self) } }
        
    var namedLocation: String? {
        get { self.value( NSMetadataItemNamedLocationKey, type: String.self) } }
        
    var gpsStatus: String? {
        get { self.value( NSMetadataItemGPSStatusKey, type: String.self) } }
        
    var gpsMeasureMode: String? {
        get { self.value( NSMetadataItemGPSMeasureModeKey, type: String.self) } }
        
    var gpsdop: Double? {
        get { self.value( NSMetadataItemGPSDOPKey, type: Double.self) } }
        
    var gpsMapDatum: String? {
        get { self.value( NSMetadataItemGPSMapDatumKey, type: String.self) } }
        
    var gpsDestLatitude: Double? {
        get { self.value( NSMetadataItemGPSDestLatitudeKey, type: Double.self) } }
        
    var gpsDestLongitude: Double? {
        get { self.value( NSMetadataItemGPSDestLongitudeKey, type: Double.self) } }
        
    var gpsDestBearing: Double? {
        get { self.value( NSMetadataItemGPSDestBearingKey, type: Double.self) } }
        
    var gpsDestDistance: Double? {
        get { self.value( NSMetadataItemGPSDestDistanceKey, type: Double.self) } }
        
    var gpsProcessingMethod: String? {
        get { self.value( NSMetadataItemGPSProcessingMethodKey, type: String.self) } }
        
    var gpsAreaInformation: String? {
        get { self.value( NSMetadataItemGPSAreaInformationKey, type: String.self) } }
        
    var gpsDateStamp: Date? {
        get { self.value( NSMetadataItemGPSDateStampKey, type: Date.self) } }
        
    var gpsDifferental: Double? {
        get { self.value( NSMetadataItemGPSDifferentalKey, type: Double.self) } }
        
    var codecs: [String]? {
        get { self.value( NSMetadataItemCodecsKey, type: [String].self) } }
        
    var mediaTypes: [String]? {
        get { self.value( NSMetadataItemMediaTypesKey, type: [String].self) } }
        
    var streamable: Bool? {
        get { self.value( NSMetadataItemStreamableKey, type: Bool.self) } }
        
    var totalBitRate: Double? {
        get { self.value( NSMetadataItemTotalBitRateKey, type: Double.self) } }
        
    var videoBitRate: Double? {
        get { self.value( NSMetadataItemVideoBitRateKey, type: Double.self) } }
        
    var audioBitRate: Double? {
        get { self.value( NSMetadataItemAudioBitRateKey, type: Double.self) } }
        
    var deliveryType: String? {
        get { self.value( NSMetadataItemDeliveryTypeKey, type: String.self) } }
        
    var album: String? {
        get { self.value( NSMetadataItemAlbumKey, type: String.self) } }
        
    var hasAlphaChannel: Bool? {
        get { self.value( NSMetadataItemHasAlphaChannelKey, type: Bool.self) } }
        
    var redEyeOnOff: Bool? {
        get { self.value( NSMetadataItemRedEyeOnOffKey, type: Bool.self) } }
        
    var meteringMode: String? {
        get { self.value( NSMetadataItemMeteringModeKey, type: String.self) } }
        
    var maxAperture: Double? {
        get { self.value( NSMetadataItemMaxApertureKey, type: Double.self) } }
        
    var fNumber: Double? {
        get { self.value( NSMetadataItemFNumberKey, type: Double.self) } }
        
    var exposureProgram: String? {
        get { self.value( NSMetadataItemExposureProgramKey, type: String.self) } }
        
    var exposureTimeString: String? {
        get { self.value( NSMetadataItemExposureTimeStringKey, type: String.self) } }
        
    var headline: String? {
        get { self.value( NSMetadataItemHeadlineKey, type: String.self) } }
        
    var instructions: String? {
        get { self.value( NSMetadataItemInstructionsKey, type: String.self) } }
        
    var city: String? {
        get { self.value( NSMetadataItemCityKey, type: String.self) } }
        
    var stateOrProvince: String? {
        get { self.value( NSMetadataItemStateOrProvinceKey, type: String.self) } }
        
    var country: String? {
        get { self.value( NSMetadataItemCountryKey, type: String.self) } }
        
    var textContent: String? {
        get { self.value( NSMetadataItemTextContentKey, type: String.self) } }
        
    var audioSampleRate: Double? {
        get { self.value( NSMetadataItemAudioSampleRateKey, type: Double.self) } }
        
    var audioChannelCount: Double? {
        get { self.value( NSMetadataItemAudioChannelCountKey, type: Double.self) } }
        
    var tempo: Double? {
        get { self.value( NSMetadataItemTempoKey, type: Double.self) } }
        
    var keySignature: String? {
        get { self.value( NSMetadataItemKeySignatureKey, type: String.self) } }
        
    var timeSignature: String? {
        get { self.value( NSMetadataItemTimeSignatureKey, type: String.self) } }
        
    var audioEncodingApplication: String? {
        get { self.value( NSMetadataItemAudioEncodingApplicationKey, type: String.self) } }
        
    var composer: String? {
        get { self.value( NSMetadataItemComposerKey, type: String.self) } }
        
    var lyricist: String? {
        get { self.value( NSMetadataItemLyricistKey, type: String.self) } }
        
    var audioTrackNumber: Double? {
        get { self.value( NSMetadataItemAudioTrackNumberKey, type: Double.self) } }
        
    var recordingDate: Date? {
        get { self.value( NSMetadataItemRecordingDateKey, type: Date.self) } }
        
    var musicalGenre: String? {
        get { self.value( NSMetadataItemMusicalGenreKey, type: String.self) } }
        
    var isGeneralMidiSequence: Bool? {
        get { self.value( NSMetadataItemIsGeneralMIDISequenceKey, type: Bool.self) } }
        
    var recordingYear: Double? {
        get { self.value( NSMetadataItemRecordingYearKey, type: Double.self) } }
        
    var organizations: [String]? {
        get { self.value( NSMetadataItemOrganizationsKey, type: [String].self) } }
        
    var languages: [String]? {
        get { self.value( NSMetadataItemLanguagesKey, type: [String].self) } }
        
    var rights: String? {
        get { self.value( NSMetadataItemRightsKey, type: String.self) } }
        
    var publishers: [String]? {
        get { self.value( NSMetadataItemPublishersKey, type: [String].self) } }
        
    var contributors: [String]? {
        get { self.value( NSMetadataItemContributorsKey, type: [String].self) } }
        
    var coverage: [String]? {
        get { self.value( NSMetadataItemCoverageKey, type: [String].self) } }
        
    var subject: String? {
        get { self.value( NSMetadataItemSubjectKey, type: String.self) } }
        
    var theme: String? {
        get { self.value( NSMetadataItemThemeKey, type: String.self) } }
        
    var description: String? {
        get { self.value( NSMetadataItemDescriptionKey, type: String.self) } }
        
    var identifier: String? {
        get { self.value( NSMetadataItemIdentifierKey, type: String.self) } }
        
    var audiences: [String]? {
        get { self.value( NSMetadataItemAudiencesKey, type: [String].self) } }
        
    var numberOfPages: Double? {
        get { self.value( NSMetadataItemNumberOfPagesKey, type: Double.self) } }
        
    var pageWidth: Double? {
        get { self.value( NSMetadataItemPageWidthKey, type: Double.self) } }
        
    var pageHeight: Double? {
        get { self.value( NSMetadataItemPageHeightKey, type: Double.self) } }
        
    var securityMethod: Double? {
        get { self.value( NSMetadataItemSecurityMethodKey, type: Double.self) } }
        
    var creator: String? {
        get { self.value( NSMetadataItemCreatorKey, type: String.self) } }
        
    var encodingApplications: [String]? {
        get { self.value( NSMetadataItemEncodingApplicationsKey, type: [String].self) } }
        
    var dueDate: Date? {
        get { self.value( NSMetadataItemDueDateKey, type: Date.self) } }
        
    var starRating: Double? {
        get { self.value( NSMetadataItemStarRatingKey, type: Double.self) } }
        
    var phoneNumbers: [String]? {
        get { self.value( NSMetadataItemPhoneNumbersKey, type: [String].self) } }
        
    var emailAddresses: [String]? {
        get { self.value( NSMetadataItemEmailAddressesKey, type: [String].self) } }
        
    var instantMessageAddresses: [String]? {
        get { self.value( NSMetadataItemInstantMessageAddressesKey, type: [String].self) } }
        
    var kind: [String]? {
        get { self.value( NSMetadataItemKindKey, type: [String].self) } }
        
    var recipients: [String]? {
        get { self.value( NSMetadataItemRecipientsKey, type: [String].self) } }
        
    var finderComment: String? {
        get { self.value( NSMetadataItemFinderCommentKey, type: String.self) } }
        
    var fonts: [String]? {
        get { self.value( NSMetadataItemFontsKey, type: [String].self) } }
        
    var appleLoopsRootKey: String? {
        get { self.value( NSMetadataItemAppleLoopsRootKeyKey, type: String.self) } }
        
    var appleLoopsKeyFilterType: String? {
        get { self.value( NSMetadataItemAppleLoopsKeyFilterTypeKey, type: String.self) } }
        
    var appleLoopsLoopMode: String? {
        get { self.value( NSMetadataItemAppleLoopsLoopModeKey, type: String.self) } }
        
    var appleLoopDescriptors: [String]? {
        get { self.value( NSMetadataItemAppleLoopDescriptorsKey, type: [String].self) } }
        
    var musicalInstrumentCategory: String? {
        get { self.value( NSMetadataItemMusicalInstrumentCategoryKey, type: String.self) } }
        
    var musicalInstrumentName: String? {
        get { self.value( NSMetadataItemMusicalInstrumentNameKey, type: String.self) } }

    var cfBundleIdentifier: String? {
        get { self.value( NSMetadataItemCFBundleIdentifierKey, type: String.self) } }

    var information: String? {
        get { self.value( NSMetadataItemInformationKey, type: String.self) } }

    var director: String? {
        get { self.value( NSMetadataItemDirectorKey, type: String.self) } }

    var producer: String? {
        get { self.value( NSMetadataItemProducerKey, type: String.self) } }

    var genre: String? {
        get { self.value( NSMetadataItemGenreKey, type: String.self) } }

    var performers: [String]? {
        get { self.value( NSMetadataItemPerformersKey, type: [String].self) } }

    var originalFormat: String? {
        get { self.value(NSMetadataItemOriginalFormatKey, type: String.self) } }

    var originalSource: String? {
        get { self.value(NSMetadataItemOriginalSourceKey, type: String.self) } }

    var authorEmailAddresses: [String]? {
        get { self.value( NSMetadataItemAuthorEmailAddressesKey, type: [String].self) } }

    var recipientEmailAddresses: [String]? {
        get { self.value( NSMetadataItemRecipientEmailAddressesKey, type: [String].self) } }

    var authorAddresses: [String]? {
        get { self.value( NSMetadataItemAuthorAddressesKey, type: [String].self) } }

    var recipientAddresses: [String]? {
        get { self.value( NSMetadataItemRecipientAddressesKey, type: [String].self) } }

    var isLikelyJunk: Bool? {
        get { self.value( NSMetadataItemIsLikelyJunkKey, type: Bool.self) } }

    var executableArchitectures: [String]? {
        get { self.value( NSMetadataItemExecutableArchitecturesKey, type: [String].self) } }

    var executablePlatform: String? {
        get { self.value(NSMetadataItemExecutablePlatformKey, type: String.self) } }

    var applicationCategories: [String]? {
        get { self.value( NSMetadataItemApplicationCategoriesKey, type: [String].self) } }

    var isApplicationManaged: Bool? {
        get { self.value(NSMetadataItemIsApplicationManagedKey, type: Bool.self) } }
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
