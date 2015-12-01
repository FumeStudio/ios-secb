//
//  Constants.h
//  TechnicalTest
//

#define Base_Service_URL @"http://secb.linkdev.com/webapi/api/"

#define SendContactUsForm_URLSuffix @"user/ContactUs"

#define GetEServicesList_URLSuffix @"Requests/GetRequests"
#define GetEServicesRequestTpyes_URLSuffix @"Requests/GetRequesttypes"
#define GetWorkSpaceModes_URLSuffix @"Requests/GetWorkSpaceModes"


#define Get_User_Statistics @"requests/GetUserTasksStatistics"

#define ForgetPassword_URLSuffix @"user/ForgetPassword"

#define GetOrganizersList_URLSuffix @"Organizer/Getorganizer"

#define GetLocatoinsList_URLSuffix @"location/GetLocation"
#define GetLocationTypes_URLSuffix @"location/GetlocationTypes"
#define GetLocationDetails_URLSuffix @"location/GetLocationByID"


#define GetPhotoGalleries_URLSuffix     @"photos/getphotos"
#define GetVideoGalleries_URLSuffix     @"Videos/GetVideos"

#define GetNewsCategories_URLSuffix     @"News/GetNewsCategories"
#define GetNewsList_URLSuffix           @"News/GetNews"

#define GetEventCategories_URLSuffix     @"events/GetEventsCategories"
#define GetEventsList_URLSuffix          @"events/GetEvents"
#define GetEventCitiesList_URLSuffix     @"events/GetCities"



#define MatchesListURLSuffix @"matches"
#define TeamDetailsURLSuffix @"teams"

#define DefaultItemsPerPage 20

#define APIKeyHTTPHeader [NSDictionary dictionaryWithObject:@"IF6LzD8yaymshk8oXW5ARYSszyOvp1Ar15SjsnhRPyQbFjhVUA" forKey:@"X-Mashape-Key"]

#define IsCurrentLangaugeArabic [LocalizationManager sharedInstance].language == UILanguageArabic
#define isIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


#define NewsCategoryAll @"All"

