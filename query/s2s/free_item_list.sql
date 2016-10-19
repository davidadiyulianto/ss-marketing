select `date` AS shipment_date,
S.bank_name,
        OL.public_id,
        OL.remarks,
        OL.delivery_city,
        OL.delivery_province,
        OL.payment_method_name,
        S.variant_sku,
        S.variant_name,
        S.quantity,
        S.total_sell_price,
        S.buying_price,
        (S.total_sell_price-S.buying_price) AS 'profit',
        S.source,
        S.original_sub_category AS 'category',
        S.order_created_date AS 'order_date',
        S.grand_total,
        OL.grand_total from derived.sales S
        left join `order`.order_lookup OL
        ON OL.entity_id = S.order_entity_id
where S.free_item
order by 1