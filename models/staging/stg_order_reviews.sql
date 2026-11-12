select
    review_id,
    order_id,
    review_score,
    review_comment_title    as comment_title,
    review_comment_message  as comment_message,
    review_creation_date    as created_at,
    review_answer_timestamp as answered_at
from {{ source('olist', 'raw_order_reviews') }}
qualify row_number() over (
    partition by order_id
    order by review_answer_timestamp desc, review_creation_date desc, review_id
) = 1