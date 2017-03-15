CASE 
/* FACEBOOK */
                    WHEN
                        utm_campaign ILIKE 'FB-PE'
                    THEN 'FB-PE'

                    WHEN
                        (
                            utm_source ILIKE 'facebook.com' 
                            OR 
                            utm_source ILIKE 'facebook'
                        ) 
                        AND 
                        utm_medium ILIKE 'social'
                    THEN 'SC-FB'
                    
                    WHEN
                        utm_source ILIKE 'FACEBOOK' 
                        AND
                        utm_medium ILIKE 'PAID-SOCIAL' 
                        AND
                        utm_campaign not ILIKE '%-RT-%' 
                        AND
                        utm_campaign not ILIKE '%CUSTOMER%'
                    THEN 'TCA-FB'

                    WHEN
                        utm_source ILIKE 'FACEBOOK' 
                        AND
                        utm_campaign ILIKE '%-RT-VS%'
                        AND
                        utm_campaign NOT ILIKE '%-CU-%' 
                        AND
                        utm_campaign NOT ILIKE '%CUSTOMER%'
                    THEN 'TRT-FB'

                    WHEN
                        utm_source ILIKE '%FACEBOOK%' 
                        AND 
                            (
                            utm_campaign ILIKE '%-RT-CU-%' 
                            OR
                            utm_campaign ILIKE '%CUSTOMER%'
                            )
                    THEN 'MOFU-FB'

                    WHEN utm_source = 'Facebook Ads'
                        AND 
                        utm_campaign ILIKE '%-AI-%'
                    THEN 'TCA-FACEBOOK'

                    WHEN
                        utm_source ILIKE 'instagram'
                        AND
                        utm_medium ILIKE 'PAID-DISPLAY'
                    THEN 'TOFU-Insta'

/* GOOGLE */
                    WHEN
                        utm_source ILIKE 'GOOGLE'
                        AND
                        (
                        utm_campaign ILIKE '%-event%'
                        OR
                        utm_campaign ILIKE '%-CA%'
                        OR
                        utm_campaign ILIKE '%-TC%'
                        )
                        AND
                        utm_campaign not ILIKE '%-RT%'   
                    THEN 'TCA-GOOGLE'

                    WHEN
                        utm_source ILIKE 'google'
                        AND
                        (
                        utm_campaign ILIKE '%search%'
                        OR
                        utm_campaign ILIKE '%-RT%'
                        )
                    THEN 'TRT-GOOGLE'

                    WHEN
                        utm_source = 'google' 
                        AND
                        utm_medium = 'organic'
                    THEN 'Organic-search'

                    WHEN utm_source = 'googleadwords_int'
                    THEN 'TCA-google'

                    WHEN utm_source = 'googleadwordsoptimizer_int'
                    THEN 'TRT-google'

/* Criteo*/
                    WHEN
                        utm_source ILIKE 'CRITEO'
                        AND
                            (
                            utm_medium ILIKE '%FC'
                            OR
                            utm_campaign ILIKE '%FC-%'
                            )
                    THEN 'MOFU-CRITEO'

                    WHEN
                        utm_source ILIKE 'CRITEO'
                        AND
                            (
                            utm_medium ILIKE '%FV'
                            OR
                            utm_campaign ILIKE '%FV-%'
                            OR
                            utm_campaign = 'beli2gratis1'
                            OR
                            utm_campaign ILIKE 'coupon%%'
                            )
                    THEN 'TRT-CRITEO'

                    WHEN utm_source = 'criteo_int'
                        AND 
                        utm_campaign = 'ExistingCustomer'
                    THEN 'MOFU-CRITEO'

                    WHEN utm_source = 'criteo_int'
                        AND 
                        utm_campaign = 'NewCustomer'
                    THEN 'TRT-CRITEO'

/* RTB HOUSE */
                    WHEN
                        utm_source ILIKE 'RTBHOUSE'
                        AND
                        (
                        utm_medium ILIKE 'CPC' 
                        OR
                        utm_medium ILIKE 'PAID-DISPLAY'
                        )
                        AND
                        utm_campaign ILIKE '%buyer%'
                    THEN 'MOFU-RTBHOUSE'

                    WHEN
                        utm_source ILIKE 'RTBHOUSE'
                        AND
                        (
                        utm_medium ILIKE 'CPC' 
                        OR 
                        utm_medium ILIKE 'PAID-DISPLAY'
                        )
                        AND
                        utm_campaign not ILIKE '%buyer%'
                    THEN 'TRT-RTBHOUSE'

/* NON PAID */
                    WHEN utm_source = 'Install-organic'
                    THEN 'Install-organic'

                    WHEN
                        utm_source = 'instagram' 
                        AND
                        utm_medium = 'social'
                    THEN 'SC-insta'

                    WHEN utm_source ILIKE 'BBM' 
                        AND
                        utm_medium ILIKE 'SOCIAL'
                    THEN 'SC-BBM'

                    WHEN utm_source = 'line'
                        AND
                        utm_medium = 'social'
                    THEN 'SC-LINE'

                    WHEN utm_source = 'line'
                        AND
                        utm_medium = 'chat'
                    THEN 'LINE-chat'

                    WHEN 
                        utm_medium ILIKE 'EMAIL'
                    THEN 'EMAIL'

                    WHEN 
                        utm_medium ILIKE 'SMS'
                    THEN 'SMS'

                    WHEN
                        utm_source ILIKE 'OneSignal'
                        OR
                        utm_source ILIKE 'Parse'
                        OR
                        utm_medium ILIKE 'Pushnot' 
                        OR
                        utm_medium ILIKE 'ONESIGNAL'
                        OR
                            (
                            utm_source ILIKE 'markotop'
                            AND
                            utm_medium ILIKE 'APPS'
                            )
                    THEN 'Pushnotif'

                     WHEN
                        (
                        utm_source is null 
                        AND
                        utm_campaign = 'tvc'
                        ) 
                        OR
                        utm_medium = 'tvc'
                    THEN 'TVC'

                    WHEN
                        (
                        utm_source = 'direct'
                        AND
                        utm_medium IS NULL
                        )
                        OR
                        (
                        utm_source IS NULL
                        AND
                        utm_medium IS NULL
                        AND
                        ua.public_id IS NULL
                        )
                    THEN 'direct'

                    WHEN
                        utm_medium = 'messages'
                    THEN 'chat'

                    WHEN
                        utm_source = 'quiz-maker'
                    THEN 'BNB'

                    WHEN utm_source = 'website'
                        AND
                        utm_campaign = 'smartbanner'
                    THEN 'website-banner'
/* TOFU partner */

                WHEN utm_source = 'inmobi_int'
                    AND 
                    utm_campaign = 'NewCustomer'
                THEN 'TRT-inmobi'

                WHEN utm_source = 'artofclick'
                THEN 'TCA-ARTOFCLICK'

                WHEN utm_source = 'Vungle_int'
                THEN 'TCA-Vungle'

                WHEN utm_source = 'mobrain_int'
                THEN 'TCA-mobrain'
                    
                WHEN utm_source = 'mobomarket_int'
                THEN 'TCA-mobomarket'

                WHEN utm_source = 'molocco_int'
                THEN 'TCA-molocco'

                WHEN utm_source = 'vizury_int'
                     AND
                     utm_campaign = 'NewCustomer'
                THEN 'TRT-vizury'

/* MOFU partner */

                WHEN utm_source = 'inmobi_int'
                    AND 
                    (
                    utm_campaign = 'MOFU-Campaign'
                    OR
                    utm_campaign = 'Dormant'
                    )
                THEN 'MOFU-inmobi'

                WHEN utm_source = 'revx_int'
                THEN 'MOFU-ve'

                ELSE 'others'
                END AS channel

/* jgn lupa tambahin public id atau order kalau butuh */