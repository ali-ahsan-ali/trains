# The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
from firebase_functions import scheduler_fn, logger
import requests

import asyncio
from aioapns import APNs, NotificationRequest, PushType

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
import time    

app = initialize_app()

# Run once a day at midnight, to clean up inactive users.
# Manually run the task here https://console.cloud.google.com/cloudscheduler
@scheduler_fn.on_schedule(
    # schedule="* 8 * * 1-5",
    schedule="0 8 * * 1-5",
    timezone=scheduler_fn.Timezone("Australia/Sydney"),
)
def startLiveActivity(event: scheduler_fn.ScheduledEvent) -> None:
    """Start live activity for all users"""

    firestore_client: google.cloud.firestore.Client = firestore.client()    
    trip_bearer_token = "apikey something-0DxnsR0"
    trip_headers = {
        "Authorization": f"{trip_bearer_token}",
        "Accept": "application/json"
    }
    trip_url = 'https://api.transport.nsw.gov.au/v1/tp/trip'
    
    for doc in firestore_client.collection("pushTokens").stream():
        pushToStartToken = doc.to_dict().get("pushToStartToken")
        startStopId = doc.to_dict().get("favouriteTrip").get("startStopId")
        startStopName = doc.to_dict().get("favouriteTrip").get("startStopName")
        endStopId = doc.to_dict().get("favouriteTrip").get("endStopId")
        endStopName = doc.to_dict().get("favouriteTrip").get("endStopName")
        if pushToStartToken == None or startStopId == None or endStopId == None or startStopName == None or endStopName == None: continue 
        params = {
             "outputFormat": "rapidJSON",
            "coordOutputFormat": "EPSG:4326",
            "depArrMacro": "dep",
            "type_origin": "any",
            "name_origin": startStopId,
            "type_destination": "any",
            "name_destination": endStopId,
            "calcNumberOfTrips": "10" ,
            "excludedMeans": "checkbox",
            "exclMOT_4": "1",
            "exclMOT_5": "1",
            "exclMOT_7": "1",
            "exclMOT_9": "1",
            "exclMOT_11": "1",
            "TfNSWTR": "true",
            "itOptionsActive": "0",
            "computeMonomodalTripBicycle": "false",
            "cycleSpeed": "10",
            "version": "10.2.1.42",
        }
        
        response = requests.get(trip_url, params=params, headers=trip_headers)
        data = response.json()

        trips=[{
            "startTime": 734617110,
            "endTime": 734617111
        }]
        for journey in data["journeys"]:
            legs = journey["legs"]
            if len(legs) < 1: 
                logger.log("LESS THAN 1")
                continue 
            if "origin" not in legs[0] or "departureTimeEstimated" not in legs[0]["origin"]: 
                logger.log("No departure")
                continue
            if "destination" not in legs[-1] or "arrivalTimeEstimated" not in legs[-1]["destination"]: 
                logger.log("No Arrival")
                continue
            
            if legs[0]["origin"]["departureTimeEstimated"] != None and  legs[-1]["destination"]["arrivalTimeEstimated"] != None :
                # trips.append(
                #     {
                #         "startTime": legs[0]["origin"]["departureTimeEstimated"],
                #         "endTime": legs[-1]["destination"]["arrivalTimeEstimated"]
                #     }
                # )
                break
        
        apns_data = {
            "aps": {
                "timestamp": f'{time.time()}',
                "event": "start",
                "content-state": {
                    "times": trips
                },
                "attributes-type": "LiveTrainsAttributes",
                "attributes": {
                    "startStopName": f"{startStopName}",
                    "endStopName": f"{endStopName}"
                },
                "alert": {
                    "title": "Trains are Arriving",
                    "body": "Check to see the latest trains from your favourite trip",
                    "sound": "chime.aiff"
                }
            }
        }        
        request = NotificationRequest(
            device_token=f'{pushToStartToken}',
            message = apns_data,
            priority=10,
            push_type=PushType.LIVEACTIVITY,
            apns_topic="Ali.Trains.push-type.liveactivity"
        )
        result = asyncio.run(makeApnsPost(request=request))
        logger.log(result.description, result.status, result.timestamp, result.notification_id)
    logger.log("FINISHED")
    

async def makeApnsPost(request: NotificationRequest):
    apns_key_client = APNs(
        use_sandbox=True,
    )
    logger.log("Sending Request...")
    return await apns_key_client.send_notification(request)
