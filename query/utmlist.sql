case 
/* FACEBOOK */
        
        WHEN
            utm_campaign ILIKE 'FB-PE'
            THEN 
            'FB-PE'
        WHEN
            (
                utm_source ILIKE 'facebook.com' 
                OR 
                utm_source ILIKE 'facebook'
            ) 
            AND 
            utm_medium ILIKE 'social'
            THEN 
            'SC-FB'
        
        WHEN
            utm_source ILIKE 'FACEBOOK' 
            AND
            utm_medium ILIKE 'PAID-SOCIAL' 
            AND
            utm_campaign not ILIKE '%-RT-%' 
            AND
            utm_campaign not ILIKE '%CUSTOMER%'
            THEN 
            'TCA-FB'

        WHEN
            utm_source ILIKE 'FACEBOOK' 
            AND
            utm_campaign ILIKE '%-RT-%' 
            AND
            utm_campaign NOT ILIKE '%-CU-%' 
            AND
            utm_campaign NOT ILIKE '%CUSTOMER%'
            THEN 
            'TRT-FB'

        WHEN
            utm_source ILIKE '%FACEBOOK%' 
            AND 
                (
                utm_campaign ILIKE '%-RT-CU-%' 
                OR
                utm_campaign ILIKE '%CUSTOMER%'
                )
            THEN 
            'MOFU-FB'
/* GOOGLE */
        
WHEN
            utm_source ILIKE 'GOOGLE' 
            AND
            (
            utm_campaign ILIKE '%-TC-%'
            AND
            utm_campaign NOT ILIKE '%-AE-%'
            )
            THEN 
            'TCA-Google'

   WHEN 
            utm_source ILIKE 'GOOGLE' 
            AND 
                ((
                UTM_CAMPAIGN ILIKE '%search%'
                or
                utm_campaign ILIKE '%web%'
                )
                or
                utm_campaign ILIKE '%-AE-%'
                OR 
                UTM_CAMPAIGN ILIKE '%-RT-VS-%'
                )
            THEN 
            'TRT-Google'
    WHEN
            utm_source ILIKE 'google'
            and
            utm_medium ILIKE 'cpc'
            and
            utm_campaign ILIKE '-display'
            and
            (
            utm_campaign ILIKE '%event%'
            or
            utm_campaign ILIKE '%-CA%'
            )
            THEN
            'TCA-display'

    WHEN
            utm_source ILIKE 'google'
            and
            utm_medium ILIKE 'cpc'
            and
            utm_campaign ILIKE '-display'
            and
            (
            utm_campaign ILIKE '%gdisplay%'
            and
            utm_campaign ILIKE '%-RT-VS-%'
            )
            THEN
            'TRT-display'
            
/* SOCMED */
    WHEN
            utm_source = 'instagram' 
            AND
            utm_medium = 'social'
            THEN 
            'SC-insta'
    WHEN
            utm_source ILIKE 'BBM' 
            AND
            utm_medium ILIKE 'SOCIAL'
            THEN 
            'SC-BBM'

    WHEN
            utm_source ILIKE 'LINE%' 
            THEN 
            'LINE'
    WHEN
            utm_source ILIKE 'instagram'
            AND
            utm_medium ILIKE 'PAID-DISPLAY'
            THEN
            'TOFU-Insta'

/* MOFU */
    WHEN 
            utm_medium ILIKE 'EMAIL'
            THEN 
            'EMAIL'

    WHEN 
            utm_medium ILIKE 'SMS'
            THEN 
            'SMS'

    WHEN
            utm_medium ILIKE 'Pushnot' 
            OR
            utm_medium ILIKE 'ONESIGNAL'
            OR
            (
            utm_source ILIKE 'markotop'
            and
            utm_medium ILIKE 'APPS'
            )
            THEN 
            'Pushnotif'


/* MOFU PARTNER */
    WHEN
            utm_source ILIKE 'CRITEO'
            AND
                (
                utm_medium ILIKE '%FC'
                OR
                utm_campaign ILIKE '%FC-%'
                )
            THEN 
            'MOFU-CRITEO'
    WHEN
            utm_source ILIKE 'RTBHOUSE'
            AND
            (
            utm_medium ILIKE 'CPC' 
            or 
            utm_medium ILIKE 'PAID-DISPLAY'
            )
            AND
            utm_campaign ILIKE '%buyer%'
            THEN 'MOFU-RTBHOUSE'

/* TOFU PARTNER */  
    WHEN
            utm_source ILIKE 'CRITEO'
            AND
                (
                utm_medium ILIKE '%FV'
                OR
                utm_campaign ILIKE '%FV-%'
                OR
                utm_campaign = 'beli2gratis1'
                or
                utm_campaign ILIKE 'coupon%%'
                )
            THEN 
            'TRT-CRITEO'
    WHEN
            utm_source ILIKE 'freakout'
            AND
                (
            utm_medium ILIKE 'PAID-SOCIAL'
            or
            utm_medium ILIKE 'PAID-DISPLAY'
            )
            THEN 'TCA-FREAKOUT'
    WHEN
            utm_source ILIKE 'BABE'
            AND
                (
            utm_medium ILIKE 'CPC'
            or
            utm_medium ILIKE 'PAID-DISPLAY'
            )
            THEN 'TCA-BABE'
    WHEN
            utm_source ILIKE 'ADSKOM'
            AND
            utm_medium ILIKE 'CPC'
            THEN 'TCA-ADSKOM'
    WHEN
            utm_source ILIKE 'INNITY'
            AND
                (
            utm_medium ILIKE 'CPC'
            OR
            utm_medium ILIKE 'PAID-DISPLAY'
            )
            THEN 'TCA-INNITY'
    WHEN
            utm_source ILIKE 'IMX'
            AND
            utm_medium ILIKE 'CPC'
            THEN 'TCA-IMX'
    WHEN
            utm_source ILIKE 'BBM'
            AND
            utm_medium ILIKE 'PAID%'
            THEN 'TCA-BBM'
    WHEN
            utm_source ILIKE 'RTBHOUSE'
            AND
            (
            utm_medium ILIKE 'CPC' 
            or 
            utm_medium ILIKE 'PAID-DISPLAY'
            )
            AND
            utm_campaign not ILIKE '%buyer%'
            THEN 'TRT-RTBHOUSE'
/* TVC */
        WHEN
            (
                utm_source is null AND
                utm_campaign = 'tvc'
            ) 
            OR
            utm_medium = 'tvc'
            THEN 'TVC'
/* ORGANIC */ 
        WHEN
            utm_source = 'google' 
            AND
            utm_medium ='organic'
            THEN 
            'Gorganic'
        WHEN    
            utm_source = 'direct' 
            and
            (utm_medium is null or utm_medium = '')
            and
            ua.public_id is null
            THEN
            'direct'
        WHEN    
           ua.public_id IS NOT NULL 
            THEN
            'ORDER'
/*chat*/
        WHEN
            utm_medium = 'messages'
            THEN
            'chat'

/*bnb*/
        WHEN
            utm_source = 'quiz-maker'
            THEN
            'BNB'
            else