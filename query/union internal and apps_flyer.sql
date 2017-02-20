with a as 
(
SELECT 
	*
FROM
(
	SELECT
		utm_time,
		cookie_id,
		CASE 
		WHEN utm_source = 'inmobi_int'
			 AND 
		 	 utm_campaign = 'NewCustomer'
		THEN 'TRT-inmobi'

		WHEN utm_source = 'inmobi_int'
		 	AND 
			 (
			 utm_campaign = 'MOFU-Campaign'
			 OR
			 utm_campaign = 'Dormant'
			 )
		THEN 'MOFU-inmobi'

		WHEN utm_source = 'criteo_int'
			 AND 
			 utm_campaign = 'ExistingCustomer'
		THEN 'MOFU-criteo'

		WHEN utm_source = 'vizury_int'
			 AND
			 utm_campaign = 'NewCustomer'
		THEN 'TRT-vizury'

		WHEN utm_source = 'criteo_int'
			 AND 
			 utm_campaign = 'NewCustomer'
		THEN 'TRT-criteo'

		WHEN utm_source ILIKE 'OneSignal'
			 OR
			 utm_source ILIKE 'Parse'
		THEN 'Pushnot'

		WHEN utm_source ILIKE '%FACEBOOK%' 
	         AND 
	         (
	         utm_campaign ILIKE '%-RT-CU-%' 
	         OR
	         utm_campaign ILIKE '%CUSTOMER%'
	         )
	     THEN 'MOFU-FB'

	    WHEN utm_source = 'revx_int'
	    THEN 'MOFU-revx'

	    WHEN utm_source ILIKE 'CRITEO'
	        AND
	            (
	            utm_medium ILIKE '%FV'
	            OR
	            utm_campaign ILIKE '%FV-%'
	            OR
	            utm_campaign = 'beli2gratis1'
	            OR
	            utm_campaign ILIKE 'coupon%%'
	            OR
	            utm_campaign = 'visitor-tvc-december'
	            )
	    THEN 'TRT-CRITEO'

	    WHEN utm_source ILIKE 'CRITEO'
	        AND
	            (
	            utm_medium ILIKE '%FC'
	            OR
	            utm_campaign ILIKE '%FC-%'
	            )
	    THEN 'MOFU-CRITEO'

	     WHEN utm_medium = 'messages'
	     THEN 'chat'

	     WHEN utm_source = 'googleadwordsoptimizer_int'
	 	 THEN 'TRT-google'

	     WHEN utm_source = 'Markotop'
	     THEN 'Pushnot'

	     WHEN utm_source ILIKE 'FACEBOOK' 
	            AND
	            utm_campaign ILIKE '%-RT-%' 
	            AND
	            utm_campaign NOT ILIKE '%-CU-%' 
	            AND
	            utm_campaign NOT ILIKE '%CUSTOMER%'
	    THEN 'TRT-FB'

	    WHEN utm_source ILIKE 'FACEBOOK'
	    	AND 
	    	utm_campaign ILIKE 'FB-PE'
	    THEN 'FB-PE'
	    
	    WHEN utm_source = 'line'
	    	AND
	    	utm_medium = 'chat'
	    THEN 'LINE-chat'

	    WHEN utm_source = 'line'
	    	AND
	    	utm_medium = 'social'
	    THEN 'SC-LINE'

	    WHEN utm_source = 'bbm'
	    	AND
	    	utm_medium = 'social'
	    THEN 'SC-BBM'

	    WHEN utm_source = 'google'
	    	 AND
	    	 utm_campaign IS NOT NULL
	   	THEN 'TRT-google'

	   	WHEN utm_source = 'google'
	    	 AND
	    	 utm_campaign IS NULL
	   	THEN 'Organic-google'

	   	WHEN utm_source = 'quiz-maker'
	   	THEN 'BNB'

	   	WHEN utm_medium ILIKE 'email'
	   	THEN 'email'

	   	WHEN utm_source ILIKE 'RTBHOUSE'
	            AND
	            (
	            utm_medium ILIKE 'CPC' 
	            OR 
	            utm_medium ILIKE 'PAID-DISPLAY'
	            )
	            AND
	            utm_campaign not ILIKE '%buyer%'
	    THEN 'TRT-RTBHOUSE'

	   	WHEN utm_source = 'direct'
	   		AND
	   		utm_medium IS NULL
	   	THEN 'direct'
	   	
	   	WHEN ua.public_id IS NOT NULL
	   	THEN 'ORDER'


	   	ELSE CONCAT(IFNULL(utm_source,''),'-',IFNULL(utm_campaign,''))
	   	END AS CHANNEL

	FROM
		derived.undirect_attribute ua
	WHERE
		LENGTH(cookie_id) < 20
		AND
		utm_time >= '2016-10-01'
) raw1
UNION ALL
	
	SELECT
	utm_time,
	android_id,
	concat('install','-',channel)
	FROM
	(
		SELECT
			HOURS_ADD(click_time, 7) as utm_time,
			android_id,
			CASE 
			WHEN media_source = 'Facebook Ads' 
				AND
				agency ILIKE '%FB%'
				THEN
				'Facebook Ads'

			WHEN media_source = 'Facebook Ads' 
				AND
				agency NOT ILIKE '%FB%'
				THEN
				agency

			WHEN agency = 'rapido' 
				THEN 
				'rapido'

			WHEN agency = 'vizury' 
				THEN 
				'vizury'
			
			WHEN agency = 'socialclicks' 
				THEN 
				'socialclicks'

			WHEN agency = 'vserv'
				THEN
				'vserv'

		    WHEN agency = 'artofclick' 
		    	THEN 
		    	'artofclick'
		                 
		    WHEN agency = 'ibd' 
		    	THEN 
		    	'cheetahmobile'
		                    
		    WHEN agency = 'revx' 
		    	THEN 
		    	'revx'
		                    
		    WHEN attribution_type = 'organic' 
		    	THEN 'Organic'
			
			ELSE
				media_source
			END AS channel

		FROM
			raw.apps_flyer_events

		WHERE
			event_type = 'install'
			and
			android_id IS NOT NULL
	) raw2
)