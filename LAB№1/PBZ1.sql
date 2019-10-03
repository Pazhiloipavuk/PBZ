create table teacher (id_teacher varchar(10), surname text, 
                      post text, department text, 
                      speciality text, phone int, 
                      PRIMARY KEY (id_teacher));

INSERT INTO teacher VALUES ('221Л', 'Фролов', 'Доцент', 'ЭВМ', 'АСОИ, ЭВМ', '487'), 
                            ('222Л', 'Костин', 'Доцент', 'ЭВМ', 'ЭВМ', '543'), 
                            ('225Л', 'Бойко', 'Профессор', 'АСУ', 'АСОИ, ЭВМ', '112'), 
                            ('430Л', 'Глазов', 'Ассистент', 'ТФ', 'СД', '421'), 
                            ('110Л', 'Петров', 'Ассистент', 'Экономики', 'Международная экономика', '324');

create table subject (id_subject varchar(10), subject_name text, 
                      hours int, speciality_subject text, 
                      semester int, PRIMARY KEY (id_subject));

INSERT INTO subject VALUES ('12П', 'Мини ЭВМ', '36', 'ЭВМ', '1'), 
			                     ('14П', 'ПЭВМ', '72', 'ЭВМ', '2'), 
                           ('17П', 'СУБД ПК', '48', 'АСОИ', '4'), 
                           ('18П', 'ВКСС', '52', 'АСОИ', '6'), 
                           ('34П', 'Физика', '30', 'СД', '6'), 
                           ('22П', 'Аудит', '24', 'Бухучета', '3');

create table student_group (id_student_group varchar(10), group_name text, 
                            numbers_of_people int, speciality_group text, 
                            captain_surname text, PRIMARY KEY (id_student_group));

INSERT INTO student_group VALUES ('8Г', 'Э-12', '18', 'ЭВМ', 'Иванова'), 
                          ('7Г', 'Э-15', '22', 'ЭВМ', 'Сеткин'), 
                          ('4Г', 'АС-9', '24', 'АСОИ', 'Балабанов'), 
                          ('3Г', 'АС-8', '20', 'АСОИ', 'Чижов'), 
                          ('17Г', 'С-14', '29', 'СД', 'Амросов'), 
                          ('12Г', 'М-6', '16', 'Международная экономика', 'Трубин'),
                          ('10Г', 'Б-4', '21', 'Бухучета', 'Зязюткин');

create table teacher_student_group (id_student_group varchar(10), id_subject varchar(10), 
                                    id_teacher varchar(10), audience_number int, 
                                    FOREIGN KEY (id_student_group) REFERENCES student_group (id_student_group),
                                    FOREIGN KEY (id_subject) REFERENCES subject (id_subject), 
                                    FOREIGN KEY (id_teacher) REFERENCES teacher (id_teacher));

INSERT INTO teacher_student_group VALUES ('8Г', '12П', '222Л', '112'),
                                 ('8Г', '14П', '221Л', '220'),
                                 ('8Г', '17П', '222Л', '112'),
                                 ('7Г', '14П', '221Л', '220'),
                                 ('7Г', '17П', '222Л', '241'),
                                 ('7Г', '18П', '225Л', '210'),
                                 ('4Г', '12П', '222Л', '112'),
                                 ('4Г', '18П', '225Л', '210'),
                                 ('3Г', '12П', '222Л', '112'),
                                 ('3Г', '17П', '221Л', '241'),
                                 ('3Г', '18П', '225Л', '210'),
                                 ('17Г', '12П', '222Л', '112'),
                                 ('17Г', '22П', '110Л', '220'),
                                 ('17Г', '34П', '430Л', '118'),
                                 ('12Г', '12П', '222Л', '112'),
                                 ('12Г', '22П', '110Л', '210'),
                                 ('10Г', '12П', '222Л', '210'),
                                 ('10Г', '22П', '110Л', '210');

1)SELECT * 
  FROM teacher;

2)SELECT * 
  FROM student_group
  WHERE speciality_group = 'ЭВМ';


3)SELECT DISTINCT id_teacher, audience_number
  FROM teacher_student_group 
  WHERE id_subject = '18П';


4)SELECT DISTINCT subject.id_subject, subject.subject_name 
  FROM subject
  JOIN teacher_student_group
  USING (id_subject)
  WHERE teacher_student_group.id_teacher = 
      (SELECT id_teacher 
       FROM teacher 
       WHERE surname = 'Костин');


5)SELECT id_student_group 
  FROM teacher_student_group 
  WHERE id_teacher = 
      (SELECT id_teacher 
       FROM teacher 
       WHERE surname = 'Фролов');


6)SELECT *
  FROM subject 
  WHERE speciality_subject LIKE '%АСОИ%';


7)SELECT *
  FROM teacher
  WHERE speciality LIKE '%АСОИ%';


8)SELECT DISTINCT teacher.surname 
  FROM teacher
  JOIN teacher_student_group
  USING (id_teacher)
  WHERE teacher_student_group.audience_number = 210;


9)SELECT DISTINCT subject.subject_name, student_group.group_name
  FROM subject
  JOIN teacher_student_group
  USING (id_subject)
  JOIN student_group
  USING (id_student_group)
  WHERE audience_number BETWEEN 100 AND 200;


10)SELECT student_group_1.id_student_group, student_group_2.id_student_group
   FROM student_group student_group_1
   JOIN student_group student_group_2 
   USING (speciality_group)
   WHERE student_group_1.id_student_group > student_group_2.id_student_group;


11)SELECT SUM(numbers_of_people)
   FROM student_group
   WHERE speciality_group = '%ЭВМ%';


12)SELECT DISTINCT teacher.id_teacher
   FROM teacher
   JOIN teacher_student_group
   USING (id_teacher)
   WHERE teacher_student_group.id_student_group IN
       (SELECT id_student_group 
        FROM student_group 
        WHERE speciality_group = 'ЭВМ');


13)SELECT subject_13.id_subject
   FROM (SELECT subject.id_subject, COUNT(teacher_student_group.id_subject) AS count_subject
         FROM subject
         JOIN teacher_student_group
         USING (id_subject)
         GROUP BY subject.id_subject) AS subject_13
   WHERE subject_13.count_subject LIKE (SELECT DISTINCT COUNT(id_student_group)
                                        FROM student_group);


14)SELECT DISTINCT teacher.surname
   FROM teacher
   JOIN teacher_student_group 
   USING (id_teacher)
   WHERE teacher.surname != (SELECT DISTINCT teacher.surname
                                   FROM teacher
                                   JOIN teacher_student_group
                                   USING (id_teacher)
                                   WHERE teacher_student_group.id_subject = '14П') 
                                   AND teacher_student_group.id_subject IN 
        (SELECT id_subject
         FROM teacher_student_group
         WHERE id_teacher IN 
              (SELECT id_teacher
               FROM teacher_student_group
               WHERE id_subject = '14П'));


15)SELECT DISTINCT subject.*
   FROM subject
   JOIN teacher_student_group
   USING (id_subject)
   WHERE teacher_student_group.id_subject NOT IN 
        (SELECT subject.id_subject
         FROM subject
         JOIN teacher_student_group
         USING (id_subject)
         WHERE teacher_student_group.id_teacher = '221Л');


16)SELECT subject.*
   FROM subject
   WHERE subject.id_subject NOT IN 
        (SELECT subject.id_subject
         FROM subject
         JOIN teacher_student_group
         USING (id_subject)
         JOIN student_group
         USING (id_student_group)
         WHERE student_group.group_name = 'М-6');


17)SELECT DISTINCT teacher.*
   FROM teacher
   JOIN teacher_student_group
   USING (id_teacher)
   WHERE teacher_student_group.id_teacher IN
       (SELECT DISTINCT teacher_student_group.id_teacher
        FROM teacher_student_group
        JOIN teacher
        USING (id_teacher)
        WHERE teacher.post = 'Доцент') AND teacher_student_group.id_student_group IN 
            (SELECT DISTINCT teacher_student_group.id_student_group
             FROM teacher_student_group
             WHERE teacher_student_group.id_student_group = '3Г') OR teacher_student_group.id_student_group IN 
            (SELECT DISTINCT teacher_student_group.id_student_group
             FROM teacher_student_group
             WHERE teacher_student_group.id_student_group = '8Г');


18)SELECT DISTINCT teacher_student_group.id_subject,
                   teacher_student_group.id_teacher, 
                   teacher_student_group.id_student_group 
   FROM teacher_student_group
   JOIN teacher
   USING (id_teacher)
   WHERE teacher.speciality = '%АСОИ%' AND teacher.department = 'ЭВМ';


19)SELECT DISTINCT student_group.id_student_group
   FROM student_group
   JOIN teacher_student_group
   USING (id_student_group)
   JOIN teacher
   USING (id_teacher)
   WHERE teacher.speciality = student_group.speciality_group;


20)SELECT DISTINCT teacher.id_teacher
   FROM teacher
   JOIN teacher_student_group
   USING (id_teacher)
   JOIN student_group
   USING (id_student_group)
   JOIN subject
   USING (id_subject)
   WHERE teacher.department = 'ЭВМ' AND subject.speciality_subject = student_group.speciality_group;


21)SELECT DISTINCT student_group.speciality_group
   FROM student_group
   JOIN teacher_student_group
   USING (id_student_group)
   JOIN teacher
   USING (id_teacher)
   WHERE teacher.department = 'АСУ';


22)SELECT DISTINCT teacher_student_group.id_subject
   FROM teacher_student_group
   JOIN student_group
   USING (id_student_group)
   WHERE student_group.group_name = 'АС-8';


23)SELECT DISTINCT teacher_student_group.id_student_group
   FROM teacher_student_group
   JOIN student_group
   USING (id_student_group)
   WHERE student_group.group_name != 'АС-8' AND teacher_student_group.id_subject IN 
        (SELECT teacher_student_group.id_subject
         FROM teacher_student_group
         JOIN student_group
         USING (id_student_group)
         WHERE student_group.group_name = 'АС-8');


24)SELECT DISTINCT teacher_student_group.id_student_group
   FROM teacher_student_group
   WHERE NOT teacher_student_group.id_student_group IN 
       (SELECT DISTINCT teacher_student_group.id_student_group
        FROM teacher_student_group
        WHERE teacher_student_group.id_subject IN 
            (SELECT teacher_student_group.id_subject
             FROM teacher_student_group
             JOIN student_group
             USING (id_student_group)
             WHERE student_group.group_name = 'АС-8'));


25)SELECT DISTINCT teacher_student_group.id_student_group
   FROM teacher_student_group
   WHERE NOT teacher_student_group.id_student_group IN 
       (SELECT DISTINCT teacher_student_group.id_student_group
        FROM teacher_student_group
        WHERE teacher_student_group.id_subject IN 
            (SELECT teacher_student_group.id_subject
             FROM teacher_student_group
             JOIN teacher
             USING (id_teacher)
             WHERE teacher.id_teacher = '430Л'));


26)SELECT teacher_student_group.id_teacher
   FROM teacher_student_group
   WHERE teacher_student_group.id_student_group = 
       (SELECT student_group.id_student_group
        FROM student_group
        WHERE student_group.group_name = 'Э-15') AND teacher_student_group.id_teacher NOT IN 
            (SELECT teacher_student_group.id_teacher
             FROM teacher_student_group
             WHERE teacher_student_group.id_subject = '12П');

--------------------------------------------------------------------------------------------------------
create table producer(P varchar(10), NameP text, 
                      Status int, City text, PRIMARY KEY(P));

INSERT INTO producer VALUES ('П1', 'Петров', '20', 'Москва'),
                            ('П2', 'Синицин', '10', 'Таллинн'),
                            ('П3', 'Федоров', '30', 'Таллинн'),
                            ('П4', 'Чаянов', '20', 'Минск'),
                            ('П5', 'Крюков', '30', 'Киев');



create table part(D varchar(10), NameD text, 
                  Color text, Size int, 
                  City text, PRIMARY KEY(D));

INSERT INTO part VALUES ('Д1', 'Болт', 'Красный', '12', 'Москва'),
                        ('Д2', 'Гайка', 'Зеленая', '17', 'Минск'),
                        ('Д3', 'Диск', 'Черный', '17', 'Вильнюс'),
                        ('Д4', 'Диск', 'Черный', '14', 'Москва'),
                        ('Д5', 'Корпус', 'Красный', '12', 'Минск'),
                        ('Д6', 'Крышки', 'Красный', '19', 'Москва');



create table project(PR varchar(10), NamePR text, 
                     City text, PRIMARY KEY(PR));

INSERT INTO project VALUES ('ПР1', 'ИПР1', 'Минск'),
                           ('ПР2', 'ИПР2', 'Таллинн'),
                           ('ПР3',	'ИПР3',	'Псков'),
                           ('ПР4', 'ИПР4', 'Псков'),
                           ('ПР5', 'ИПР4', 'Москва'),
                           ('ПР6', 'ИПР6', 'Саратов'),
                           ('ПР7', 'ИПР7', 'Москва');



create table producer_project_part_number (P varchar(10), D varchar(10), 
                                           PR varchar(10), S int, 
                                           FOREIGN KEY (P) REFERENCES producer (P), FOREIGN KEY (D) REFERENCES part (D), 
                                           FOREIGN KEY (PR) REFERENCES project (PR));

INSERT INTO producer_project_part_number VALUES ('П1', 'Д1', 'ПР1', '200'),
                                                ('П1', 'Д1', 'ПР2', '700'),
                                                ('П2', 'Д3', 'ПР1', '400'),
                                                ('П2', 'Д2', 'ПР2', '200'),
                                                ('П2', 'Д3', 'ПР3', '200'),
                                                ('П2', 'Д3', 'ПР4', '500'),
                                                ('П2', 'Д3', 'ПР5', '600'),
                                                ('П2', 'Д3', 'ПР6', '400'),
                                                ('П2', 'Д3', 'ПР7', '800'),
                                                ('П2', 'Д5', 'ПР2', '100'),
                                                ('П3', 'Д3', 'ПР1', '200'),
                                                ('П3', 'Д4', 'ПР2', '500'),
                                                ('П4', 'Д6', 'ПР3', '300'),
                                                ('П4', 'Д6', 'ПР7', '300'),
                                                ('П5', 'Д2', 'ПР2', '200'),
                                                ('П5', 'Д2', 'ПР4', '100'),
                                                ('П5', 'Д5', 'ПР5', '500'),
                                                ('П5', 'Д5', 'ПР7', '100'),
                                                ('П5', 'Д6', 'ПР2', '200'),
                                                ('П5', 'Д1', 'ПР2', '100'),
                                                ('П5', 'Д3', 'ПР4', '200'),
                                                ('П5', 'Д4', 'ПР4', '800'),
                                                ('П5', 'Д5', 'ПР4', '400'),
                                                ('П5', 'Д6', 'ПР4', '500');


19)SELECT DISTINCT project.NamePR 
   FROM project
   JOIN producer_project_part_number
   USING (PR)
   WHERE producer_project_part_number.P = 'П1';


24)SELECT P 
   FROM producer 
   WHERE Status < (SELECT Status 
                   FROM producer 
                   WHERE P = 'П1');


32)SELECT DISTINCT PR
   FROM producer_project_part_number AS PPPN1
   WHERE NOT EXISTS (
                  SELECT D
                  FROM producer_project_part_number AS PPPN2
                  WHERE P = 'П1'
                    AND NOT EXISTS (
                                    SELECT *
                                    FROM producer_project_part_number
                                    WHERE producer_project_part_number.P = PPPN1.P
                                      AND producer_project_part_number.D = PPPN2.D
                                   )
                 );


1)SELECT DISTINCT project.*,
       producer_project_part_number.P,
       producer_project_part_number.D,
       producer_project_part_number.S
  FROM project
  JOIN producer_project_part_number
  USING (PR);


8)SELECT DISTINCT producer_project_part_number.P,
         producer_project_part_number.D,
         producer_project_part_number.PR
  FROM producer_project_part_number
  JOIN producer
  USING (P)
  JOIN part
  USING (D) 
  JOIN project
  USING (PR)
  WHERE producer.City != part.City OR producer.City != project.City;


14)SELECT DISTINCT producer_project_part_number_1.D, producer_project_part_number_2.D
   FROM producer_project_part_number AS producer_project_part_number_1
   JOIN producer_project_part_number AS producer_project_part_number_2
   USING (P)
   WHERE producer_project_part_number_1.D > producer_project_part_number_2.D;


18)SELECT D
   FROM producer_project_part_number
   GROUP BY D
   HAVING avg(S) > 320;


30)SELECT DISTINCT producer_project_part_number.D
   FROM producer_project_part_number
   JOIN project
   USING (PR)
   WHERE project.City = 'Лондон';


28)SELECT DISTINCT producer_project_part_number.PR
   FROM producer_project_part_number
   JOIN part
   USING (D)
   JOIN producer
   USING (P)
   WHERE producer_project_part_number.D NOT IN 
       (SELECT DISTINCT producer_project_part_number.D
        FROM producer_project_part_number
        JOIN part
        USING (D)
        WHERE part.Color = 'Красный' AND producer_project_part_number.P IN 
            (SELECT DISTINCT producer_project_part_number.P
             FROM producer_project_part_number
             JOIN producer
             USING (P)
             WHERE producer.City != 'Лондон'));


20)SELECT DISTINCT part.Color
   FROM part
   JOIN producer_project_part_number
   USING (D)
   WHERE producer_project_part_number.P = 'П1';