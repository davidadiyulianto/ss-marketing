  WITH Sales_Data AS
    (
    SELECT
      `date`,
      coupon_code,
      order_public_id,
      revenue_all,
      revenue_free_item,
      revenue_free_b2g1,
      revenue_free_b2g1_liburan,
      revenue_free_100line,
      revenue_free_bday,
      revenue_free_b3g3,
      revenue_free_1000line,
      revenue_all - revenue_free_b2g1 - revenue_free_bday - revenue_free_100line - revenue_free_b3g3 - revenue_free_1000line non_free_revenue,
      COGS_all,
      COGS_free_b2g1 + COGS_free_100line + COGS_free_bday + COGS_free_1000line + COGS_free_b2g1_liburan COGS_free,
      COGS_all - COGS_free_b2g1 - COGS_free_100line - COGS_free_bday - COGS_free_1000line - COGS_free_b2g1_liburan non_free_COGS,
      income_all,
      
      order_shipping_cost shipping_cost_all
      
    FROM
      (
      SELECT
        S.`date`,
        OL.coupon_code,
        S.order_public_id,
        SUM(S.total_sell_price) revenue_all,
        SUM(CASE WHEN S.free_item THEN S.total_sell_price ELSE 0 END) revenue_free_item,
        SUM(CASE WHEN OL.coupon_code = "s2ssalestock" THEN ABS(S.applied_discount) ELSE 0 END) revenue_free_b2g1,
        SUM(CASE WHEN OL.coupon_code = "s2sliburan" THEN ABS(S.applied_discount) ELSE 0 END) revenue_free_b2g1_liburan,
        SUM(CASE WHEN OL.coupon_code = "s2s100bjgrtsline" THEN ABS(S.applied_discount) ELSE 0 END) revenue_free_100line,
        SUM(CASE WHEN OL.coupon_code = "s2skadoultahseptember" THEN ABS(S.applied_discount) ELSE 0 END) revenue_free_bday,
        SUM(CASE WHEN (OL.coupon_code = "s2sb3get3line" OR OL.coupon_code = "LINEB3G31011") THEN ABS(S.applied_discount) ELSE 0 END) revenue_free_b3g3,
        SUM(CASE WHEN (OL.coupon_code = "LINEBJGT1017" OR OL.coupon_code = "LINEBJGT1018") THEN ABS(S.applied_discount) ELSE 0 END) revenue_free_1000line,
        SUM(S.buying_price) COGS_all,
        SUM(CASE WHEN S.free_item THEN S.buying_price ELSE 0 END) COGS_free_item,
        SUM(CASE WHEN (S.free_item AND OL.coupon_code = "s2ssalestock") THEN S.buying_price ELSE 0 END) COGS_free_b2g1,
        SUM(CASE WHEN (S.free_item AND OL.coupon_code = "s2sliburan") THEN S.buying_price ELSE 0 END) COGS_free_b2g1_liburan,
        SUM(CASE WHEN OL.coupon_code = "s2s100bjgrtsline" THEN S.buying_price ELSE 0 END) COGS_free_100line,
        SUM(CASE WHEN OL.coupon_code = "s2skadoultahseptember" THEN S.buying_price ELSE 0 END) COGS_free_bday,
        SUM(CASE WHEN OL.coupon_code = "LINEBJGT1017" OR OL.coupon_code = "LINEBJGT1018" THEN S.buying_price ELSE 0 END) COGS_free_1000line,
        SUM(S.grand_total) income_all,
        SUM(S.shipping_cost) order_shipping_cost

      FROM
        derived.sales S
        LEFT JOIN `order`.order_lookup OL ON OL.public_id = S.order_public_id

      WHERE
        S.`date` >= '2016-09-20'

      GROUP BY
        1,2,3
      ) a
),
summary AS (    
  SELECT
    S.`date`,
    SUM(S.income_all) income_all,
    SUM(S.revenue_all) all_revenue,
    SUM(S.revenue_free_item) revenue_free_item,
    SUM(S.revenue_free_b2g1) revenue_free_b2g1,
    SUM(S.revenue_free_b2g1_liburan) revenue_free_b2g1_liburan,
    SUM(S.revenue_free_100line) revenue_free_100line,
    SUM(S.revenue_free_bday) revenue_free_bday,
    SUM(S.revenue_free_b3g3) revenue_free_b3g3,
    SUM(S.revenue_free_1000line) revenue_free_1000line,
    SUM(S.non_free_revenue) non_free_revenue,
    SUM(S.COGS_all) COGS_all,
    COALESCE(LC.cogs_line,0) as cogs_line,
    SUM(S.COGS_free) COGS_free_item,
    SUM(S.non_free_COGS) non_free_COGS,
    SUM(S.shipping_cost_all) shipping_all
    
  FROM
    Sales_Data S
    LEFT JOIN (
      SELECT
        `date`,
        SUM(buying_price) as cogs_line
      FROM (
        SELECT
          S.`date`,
          S.buying_price,
          RANK() OVER(PARTITION BY S.order_public_id ORDER BY S.buying_price) as rank_cogs
        FROM
          derived.sales S
          LEFT JOIN `order`.order_lookup OL 
            ON OL.public_id = S.order_public_id
        WHERE
          OL.coupon_code = 's2sb3get3line' OR
          OL.coupon_code = 'LINEB3G31011'
      ) a

      WHERE
        rank_cogs > 3

      GROUP BY
        1

      ORDER BY
        1
      ) LC on LC.`date` = S.`date`
    
  GROUP BY
    1,13

)

SELECT
  `date`,
  income_all,
  all_revenue,
  revenue_free_item,
  revenue_free_b2g1,
  revenue_free_b2g1_liburan,
  revenue_free_100line,
  revenue_free_bday,
  revenue_free_b3g3,
  revenue_free_1000line,
  non_free_revenue,
  COGS_all,
  COGS_free_item + cogs_line COGS_free_item1,
  cogs_line,
  non_free_COGS - cogs_line non_free_COGS1,
  shipping_all
FROM
  summary
ORDER BY
  1
