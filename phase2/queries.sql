-- Query-1

-- Query-2

-- Query-3

-- Query-4

-- Query-5
SELECT q.id, q.text
FROM question AS q
EXCEPT
SELECT v.question_id, q.text
FROM question AS q,
     validates AS v
WHERE q.id = v.question_id;
-- Query-6

-- Query-7
