/*
Problem: Winners Chart (Top 3 per Contest)

Question (adapted):
There are multiple contests (events). Each participant makes multiple attempts. Only the highest score per participant per event should be considered.
You must list, for each event (contest):
The event_id
The names of contestants ranking 1st, 2nd, and 3rd, separated by commas (if ties, include all names)
Order event results by event_id
Within each rank, names should be listed in alphabetical order

If multiple participants share the same rank (because they have the same top score), they all appear in that rank’s list (tied rank).
For example, if two people tie for 1st, the next rank is 2 or should it be 3? The ranking must use dense ranking or similar so that ties share the same rank and we don’t skip ranks.
*/
WITH best_scores AS (
  SELECT
    event_id,
    participant_id,
    MAX(score) AS best_score
  FROM attempts
  GROUP BY event_id, participant_id
),
ranked AS (
  SELECT
    bs.event_id,
    p.name AS participant_name,
    bs.best_score,
    DENSE_RANK() OVER (PARTITION BY bs.event_id ORDER BY bs.best_score DESC) AS rnk
  FROM best_scores bs
  JOIN participants p ON bs.participant_id = p.id
),
filtered AS (
  SELECT event_id, participant_name, rnk
  FROM ranked
  WHERE rnk <= 3
)
SELECT
  event_id,
  GROUP_CONCAT(CASE WHEN rnk = 1 THEN participant_name END ORDER BY participant_name) AS first,
  GROUP_CONCAT(CASE WHEN rnk = 2 THEN participant_name END ORDER BY participant_name) AS second,
  GROUP_CONCAT(CASE WHEN rnk = 3 THEN participant_name END ORDER BY participant_name) AS third
FROM filtered
GROUP BY event_id
ORDER BY event_id;
