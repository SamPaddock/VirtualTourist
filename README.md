# VirtualTourist
Users can selected a location on the map and some images for the locations are shown. Users can see new images when refreshing the collection of images.

## Introduction

The application is developed to meet the requirments for the fifth and sixth project in the udacity connect - iOS development course.
* Implmenting URLSession
* Saving and loading data from CoreData
* Using MapKit library to show location on the map

### Install

#### Command Line

Open terminal app and navigate to project folders

`$ cd /Users/user/project_folders`

Clone project repository

`$ git clone https://github.com/SamPaddock/VirtualTourist.git`

## Flowchart

The following section covers the flow of the application

### On the map

A user can add a pin on the map that is then saved in-app. If the user closes the app and reopens it, the same pins that were added, will be displayed again. 
Pins can be added by a long press gesture and a single tap with display the photo album interface, which displays the photos of that tapped location.

<img src="https://github.com/SamPaddock/VirtualTourist/blob/master/VirtualTourist/Assests/Screenshots/Screenshots.xcassets/OnTheMap-pinAdded.imageset/OnTheMap-pinAdded.png?raw=true" width="200" />

### Photo Album

The photo album displays 21 photos of the selected location. The user can tap new collection to reload the photos and present a new collection of photos.
A new feature is added to filter through the photos of the selected location (section: Filter Options)

<img src="https://github.com/SamPaddock/VirtualTourist/blob/master/VirtualTourist/Assests/Screenshots/Screenshots.xcassets/PhotoAlbum-PhotosDisplied.imageset/PhotoAlbum-PhotosDisplied.png?raw=true" width="200" />  <img src="https://github.com/SamPaddock/VirtualTourist/blob/master/VirtualTourist/Assests/Screenshots/Screenshots.xcassets/PhotoAlbum-NoContentForLocation.imageset/PhotoAlbum-NoContentForLocation.png?raw=true" width="200" />  <img src="https://github.com/SamPaddock/VirtualTourist/blob/master/VirtualTourist/Assests/Screenshots/Screenshots.xcassets/PhotoAlbum-NewPhotosDisplied.imageset/PhotoAlbum-NewPhotosDisplied.png?raw=true" width="200" />

### Fliter Options

There are two filter option: Tags and Range. Tags are the hashtags added to photos by users when uploaded to the flickr server. Currently, only a single tag value can be selected. While the range filter can change the range of photos the present. the deault is city range, where all photos with the city selected is displayed. the user can change that to the region or the country of the tapped location.

<img src="https://github.com/SamPaddock/VirtualTourist/blob/master/VirtualTourist/Assests/Screenshots/Screenshots.xcassets/FilterOptions-SelectAFilter.imageset/FilterOptions-SelectAFilter.png?raw=true" width="200" />  <img src="https://github.com/SamPaddock/VirtualTourist/blob/master/VirtualTourist/Assests/Screenshots/Screenshots.xcassets/FilterOptions-FilterRange.imageset/FilterOptions-FilterRange.png?raw=true" width="200" />  <img src="https://github.com/SamPaddock/VirtualTourist/blob/master/VirtualTourist/Assests/Screenshots/Screenshots.xcassets/FilterOptions-FilterTag.imageset/FilterOptions-FilterTag.png?raw=true" width="200" />

## Technology
CoreData: Allow data to be saved in-app to avoid data lose and provide persistance in the application

## Sources
[Udacity](https://www.udacity.com/course/ios-developer-nanodegree--nd003)

## Licence
The content of this repository is licensed under a [Creative Commons Attribution License](https://creativecommons.org/licenses/by/3.0/us/) by Udacity
