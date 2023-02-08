import boto3
import time
import calendar
import json
from slack_sdk.webhook import WebhookClient
from datetime import datetime

urlHook = "https://hooks.slack.com/services/xxxxxxxx/xxxxxxxx/xxxxxxxx"
dayPeriod = 90

def dayOfWeek():
    dt = datetime.now()
    dayNumberInWeek = dt.weekday()
    return dayNumberInWeek == 1

def warningStyle(day):
    return 'danger' if day <= dayPeriod else 'primary'

def send_slack_message(payload, url):
    header = [
        {
            "type": "section",
            "text": {
                "type": "mrkdwn",
                "text": "Warning cert ssl expired, please check before due date*"
            }
        },
        {
			"type": "divider"
		}
    ]
    payload[:0]=header

    if dayOfWeek() == True: 
        webhook = WebhookClient(url)
        response = webhook.send(
            text='Hello',
            blocks=payload
        )
    else:
        response = None
    return response

def comprareDate(expire_date):
    expireDate = time.mktime(expire_date.timetuple())
    date = datetime.utcnow()
    nowDate = calendar.timegm(date.utctimetuple()) 

    format = 60 * 60 * 24

    return (float(expireDate)-float(nowDate))/(format) 

def textShows(day):
    format_float = "{:.0f}".format(day)
    if day >= 0:
        textShow = "Expire in {0} day".format(format_float)
    else:
        textShow = "Expired"
    return textShow


def expireList(domain, day):
    textShow = textShows(day)
    style = warningStyle(day)
    listExpire = {
			"type": "section",
			"text": {
				"type": "mrkdwn",
				"text": domain
			},
			"accessory": {
				"type": "button",
				"text": {
					"type": "plain_text",
					"text": textShow
				},
				"value": "click_me_123",
				"url": "https://google.com",
				"action_id": "button-action",
                "style": style
			}
		}
    return listExpire

def lambda_handler(event, context):
    client = boto3.client('acm')
    response = client.list_certificates()
    
    arr = []
    for res in response['CertificateSummaryList']:
        domainName = res['DomainName']
        expireDate = res['NotAfter']
        result = comprareDate(expireDate)
        arr.append(expireList(domainName, result))

    print(send_slack_message(arr, urlHook))

    return {
        'statusCode': 200,
        'body': json.dumps('Send success')
    }