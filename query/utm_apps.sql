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
