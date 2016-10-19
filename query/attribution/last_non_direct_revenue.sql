WITH Kafka AS (
	SELECT 
		MAX(`timestamp`) `timestamp`,
		order_id
	
	FROM 
		kafka.orders
	
	WHERE 
		event_type = 'id.salestock.domain.order.OrderShippedEvent' 
	
	GROUP BY
		order_id    
),

raw AS (
	SELECT
		UA.cookie_id,
		UA.member_id,
		UA.public_id,
		UA.utm_source,
		UA.utm_medium,
		UA.utm_campaign,
		a.total,
		a.created,
		UA.utm_time,
		row_number() over (partition by cookie_id order by utm_time) as ps,
		a.shipped_time,
		a.status_id
	FROM
		derived.undirect_attribute UA
		LEFT JOIN (
			SELECT 
				O.public_id,
				O.status_id,
				O.total,
				O.created,
				HOURS_ADD(
					CASE WHEN K.`timestamp` IS NULL THEN O.updated
						ELSE K.`timestamp`
					END, 7) shipped_time
			FROM 
				`order`.`order` O
				LEFT JOIN Kafka K
					ON O.entity_id = K.order_id

		) a ON a.public_id = UA.public_id

),

raw2 AS (
	SELECT 
		cookie_id,
		public_id,
		ps,
		ps-1 AS utm,
		total,
		created,
		shipped_time,
		status_id

	FROM
		raw
),

raw3 AS (
	SELECT
		raw2.cookie_id,
		raw2.public_id,
		raw.utm_source,
		raw.utm_medium,
		raw.utm_campaign,
		raw.utm_time,
		raw2.created,
		raw2.shipped_time,
		raw2.total
	FROM
		raw2
		LEFT JOIN raw
			ON raw2.cookie_id = raw.cookie_id AND raw2.utm = raw.ps AND (datediff(raw2.created, to_date(raw.utm_time)) <= 7)
	WHERE
		raw2.status_id = 4
),
attribute as (
SELECT
	public_id,
	total,
	created,
	CASE
		WHEN
			utm_campaign ILIKE 'FB-PE'
			THEN 'FB-PE'

		WHEN
			utm_source ILIKE 'GOOGLE' AND
			utm_campaign NOT ILIKE '%-AE-%'
			THEN 'TCA-Google'

		WHEN
			utm_source IS NULL AND
			utm_medium is NULL AND
			utm_campaign is NULL
			THEN 'direct'

		WHEN
			utm_source ILIKE 'FACEBOOK' AND
			utm_medium ILIKE 'PAID-SOCIAL' AND
			utm_campaign not ILIKE '%-RT-%' AND
			utm_campaign not ILIKE '%CUSTOMER%'
			THEN 'TCA-FB'

		WHEN
			utm_source ILIKE 'FACEBOOK' AND
			utm_campaign ILIKE '%-RT-%' AND
			utm_campaign NOT ILIKE '%-CU-%' AND
			utm_campaign NOT ILIKE '%CUSTOMER%'
			THEN 'TRT-FB'

		WHEN
			utm_source ILIKE '%FACEBOOK%' AND (
				utm_campaign ILIKE '%-RT-CU-%' OR
				utm_campaign ILIKE '%CUSTOMER%'
			)
			THEN 'MOFU-FB'

		WHEN
			utm_source ILIKE 'BAIDU' AND
			utm_medium ILIKE 'PARTNER'
			THEN 'TCA-partner'
		
		WHEN
			utm_source ILIKE 'BBM' AND
			utm_medium ILIKE 'PAID-SOCIAL'
			THEN 'TCA-BBM'
		
		WHEN
			(
				utm_source ILIKE 'WIFICOLONY' OR
				utm_source ILIKE 'freakout'
			) AND
			utm_medium ILIKE 'paid-display'
			THEN 'TCA-partner'

		WHEN
			utm_source ILIKE 'CRITEO' AND (
				utm_medium ILIKE '%FV%' OR
				utm_campaign ILIKE '%FV-%'
			)
			THEN 'TRT-CRITEO'

		WHEN
			utm_source ILIKE '%RTBHOUSE%' OR
			utm_source ILIKE '%imx%' OR
			utm_source ILIKE '%xaxis%' OR
			utm_source ILIKE 'vizury'
			THEN 'TRT-PARTNER'

		WHEN 
			utm_source ILIKE 'GOOGLE' AND
			utm_campaign ILIKE '%-AE-%'
			THEN 'TRT-Google'

		WHEN
			utm_source ILIKE 'CRITEO' AND
			utm_medium ILIKE 'paid-display' AND
			utm_campaign ILIKE '%FC-%'
			THEN 'MOFU-CR'

		WHEN
			utm_source ILIKE 'BBM' AND
			utm_medium ILIKE 'SOCIAL'
			THEN 'SC-BBM'

		WHEN
			utm_source ILIKE 'LINE%' 
			THEN 'LINE'

		WHEN
			(
				utm_source ILIKE 'facebook.com' OR 
				utm_source ILIKE 'facebook'
			) AND 
			utm_medium ILIKE 'social'
			THEN 'SC-FB'

		WHEN 
			utm_medium ILIKE 'EMAIL'
			THEN 'EMAIL'

		WHEN 
			utm_medium ILIKE 'SMS'
			THEN 'SMS'

		WHEN
			(
				utm_source is null AND
				utm_campaign = 'tvc'
			) OR
			utm_medium = 'tvc'
			THEN 'TVC'

		WHEN
			utm_source = 'google' AND
			utm_medium ='organic'
			THEN 'Gorganic'

		WHEN
			utm_medium ILIKE 'Pushnot' OR
			utm_medium ILIKE 'ONESIGNAL'
			THEN 'Pushnotif'

		WHEN
			utm_source = 'instagram' AND
			utm_medium = 'social'
			THEN 'SC-insta'
		ELSE
			'unidentified'

	END AS 'channel'
FROM
	raw3
WHERE
	shipped_time >= '2016-09-01' AND
	shipped_time <='2016-10-01'
)

SELECT
	channel,
	count(public_id) total_order,
	SUM(total) revenue
FROM
	attribute
GROUP BY
	1
ORDER BY
	3 DESC