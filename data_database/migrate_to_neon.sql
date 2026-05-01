-- ─────────────────────────────────────────────────────────────
-- Blue Ox Jobs — Supabase → Neon Data Migration
--
-- Run this AFTER neon/01_schema.sql
-- DO NOT run neon/02_seed.sql if using this file (duplicate data)
--
-- How IDs work:
--   • interns.user_id     → set to NULL so Clerk claims by email on first login
--   • startup_profiles.user_id → kept as old Supabase UUID (temporary placeholder)
--     When a startup logs in with Clerk, auth/sync re-links by email automatically
--   • pod_selections.startup_id → kept as old UUID, re-linked when startup claims profile
--   • profiles table → SKIPPED — recreated fresh when users log in with Clerk
-- ─────────────────────────────────────────────────────────────


-- ─────────────────────────────────────────────
-- 1. INTERNS  (user_id → NULL so email-claim works)
-- ─────────────────────────────────────────────
INSERT INTO public.interns (id, name, email, location, whatsapp, main_skill, skills_detail, github, portfolio, linkedin, availability, preferred_start_date, english_level, timezones, project_description, created_at, user_id)
VALUES
  ('08a7a31e-fb9c-4673-a614-26098c9e0f07','Agumya Nyson','nysonagumya@gmail.com','Mbarara,Uganda','+256755976605','Software Development','React;TypeScript;Node.js;Go;Flutter;Next.js;Docker;PostgreSQL;REST APIs;Git','nyson.me',NULL,'https://linkedln.com/in/nyson','Part-time','2026-06-01','Fluent','UTC+3 (EAT / Moscow)','I am a Full Stack Software Engineer with expertise in developing scalable web applications.','2026-04-20 21:03:34.168045+00',NULL),
  ('215d0544-d0ba-43a7-a404-4f830e9826d6','Tukwasibwe Ampfrey','ampfreytukwasibwe@gmail.com','Mbarara','+256773252005','Software Development','React;nODE.JS;Java','https://stratemedia.vercel.app/',NULL,'https://www.linkedin.com/in/tukwasibwe-ampfrey-621b272a4/','Full-time','2026-06-08','Basic','UTC+3 (EAT / Moscow)','Ampfrey Tukwasibwe, a third-year IT student at Mbarara University of Science and Technology.','2026-04-21 08:04:15.791279+00',NULL),
  ('222d950b-9886-474b-ad73-8ad1d3ba110f','Rodgers Mugagga','rodgersmugagga84@gmail.com','Mbarara Uganda','+256762557651','Software Development','React;Node;JavaScript;Mongodb;Express;Flutter;TypeScript','https://github.com/rodgersmugagga',NULL,'http://linkedin.com/in/mugaggarodgers','Full-time','2026-06-08','Fluent','UTC+3 (EAT / Moscow)','I am a second year student with hands-on experience building production applications.','2026-04-24 19:59:53.736948+00',NULL),
  ('241f31b9-530c-4fc9-b72f-fd419f5ad9f5','Aloysius Owen Jjuuko','aloysiusowenjjuuko@gmail.com','Mbarara, Uganda','+256701092219','Software Development','React;Python;Next.js;BootStrap;Java;TypeScript;Node.js;Git;Rest APIs','https://github.com/Mensorpro',NULL,'https://linkedin.com/in/aloysius-owen-jjuuko','Full-time','2026-07-01','Advanced','UTC+3 (EAT / Moscow)','I''m a final-year CS student at Mbarara University of Science and Technology (Uganda) with a strong Java/Spring Boot backend focus.','2026-04-20 17:46:49.078319+00',NULL),
  ('3ba98cf9-6be7-462e-bf8c-fb22f671740d','Tendo Mariam','tendomariam2005@gmail.com','Mbarara, Uganda','+256782679020','Other','TypeScript;Excel;SQL','',NULL,'','Part-time','2026-03-12','Fluent','UTC+0 (GMT)','I''m a first year student with Attention to detail, Basic computer knowledge.','2026-03-12 09:43:17.982835+00',NULL),
  ('3d244b00-958c-435c-8e6f-612db8822ff8','Hillary Bahati','hillarybahati24@gmail.com','Mbarara,Uganda','+256 790533780','Software Development','Python;Java','https://github.com/Larry-himth',NULL,'https://www.linkedin.com/in/ayebare-hillary-55489237a','Weekends','2026-05-11','Fluent','UTC+3 (EAT / Moscow)','im a third year student passionate in python and java software development','2026-04-20 17:35:06.785276+00',NULL),
  ('403e54d9-4f8f-4366-b3bc-fc884e4ff720','Hellen Abigail','abbyhastile@gmail.com','Mbarara Uganda','0763745281','Data & Analytics','Python;Sql','abigail@domain.com',NULL,'','Full-time','2026-06-01','Fluent','UTC+3 (EAT / Moscow)','I am second year student offering bachelor degree in information technology.','2026-03-14 07:02:38.112413+00',NULL),
  ('447fc922-b004-4792-889b-7941151c6f96','Eliya Buyana','eliyabuyana40@gmail.com','Mbarara Kokoba','+256748380360','Digital Marketing','SEO;Delivery;Email Marketing;Content Strategy','http://blueoxjobs.com',NULL,'http://blueoxjobs.com','Part-time','2026-03-23','Native','UTC+0 (GMT)','I can Make Breads, buns & cookies. I am a Photographer & Designer.','2026-03-12 09:10:28.231851+00',NULL),
  ('51ea71dc-5690-4ca9-8c41-8b9130849085','OKIROR MARK GREGORY','okirormarkgreg24@gmail.com','Mbarara, Uganda','+256764476981','Data & Analytics','Python;SQL;Power BI;Pandas;Machine Learning;Node.js','https://github.com/marxgreg24',NULL,'','Part-time','2026-04-22','Fluent','UTC+3 (EAT / Moscow)','I''m a third year Software Engineering student with a good foundation on machine learning and MLOPs.','2026-04-20 17:51:59.215131+00',NULL),
  ('53e2a056-6096-43b3-bb8e-a2e4a6661049','Ardin Malik','ardinmalik14@gmail.com','Mbarara, Uganda','+256726315664','Software Development','Go','N/A',NULL,'https://N/A','Full-time','2026-03-10','Native','UTC+3 (EAT / Moscow)','Nzbsbsbhjdndndbdb GHz','2026-03-10 13:29:35.098411+00',NULL),
  ('6130c9c5-8d91-48a6-99e9-f4882d09bb80','Amanya Peter','amanyapeter75@gmail.com','Mbarara','+256782514134','Software Development','SQL;Php;Python','https://github.com/AmanyaPeter',NULL,'https://www.linkedin.com/in/amanya-peter-787874270','Full-time','2026-06-01','Fluent','UTC+3 (EAT / Moscow)','I''m a second year computer science student starting out my journey in development.','2026-03-13 01:04:43.363416+00',NULL),
  ('71a35df8-d641-44b2-8e16-4516b6da7277','Brandon Dembe','brandondembe@gmail.com','Mbarara Uganda','+25678149546','Software Development','P;React;Python;TypeScript;Node.js;PostgreSQL;Git;Docker;MySQL;Java;HTMLcss','https://github.com/settings/profile',NULL,'','Part-time','2026-03-17','Fluent','UTC+0 (GMT)','I''m a Software Engineering student with hands-on experience building real-world products.','2026-03-10 14:42:34.168163+00',NULL),
  ('82acb30c-0abe-47df-ba78-3b33383bfa94','Noble Ahimbisibwe','nobleahimbisibwe5@gmail.com','Mbarara','+256786951347','Software Development','React;Python','nobleahimbisibwe5@gmail.com',NULL,'nobleahimbisibwe5@gmail.com','Weekends','2026-04-17','Fluent','UTC+4','I am a CS second year student that develops using flutter at a basic level.','2026-04-22 16:46:46.249336+00',NULL),
  ('9c9e91c0-60f5-47b8-a269-ed46491a5e7f','Bengo Abel Stephen','benasnkjv@gmail.com','Mbarara Uganda','+256744926694','Architecture & Engineering','','https://www.instagram.com/theharvestbitesandsips',NULL,'https://www.linkedin.com/in/abel-stephen-bengo-936a38369','Full-time','2026-02-02','Advanced','UTC+3 (EAT / Moscow)','I''m a first year culinary arts student with advancing skills in food preparation and presentation.','2026-04-16 02:14:02.369515+00',NULL),
  ('a0a75941-f652-4b51-b427-3569c03ed3f6','allan nuwamanya','allan.info.comp@gmail.com','Mbarara','+256782486240','Software Development','React;Python;TypeScript;Node.js;PostgreSQL;Git;Next.js','https://github.com/allaninfo-tech',NULL,'https://www.linkedin.com/in/allan-n-6025143b1/','Part-time','2026-06-01','Native','UTC+0 (GMT)','I am a third-year Software Engineering student experienced in JavaScript, Python, and web/mobile development.','2026-04-20 17:46:50.74003+00',NULL),
  ('b06af514-969a-48f6-8cde-4ec32b3542e7','IRADUKUNDA GRACE','2024bit088@std.must.ac.ug','Mbarara Uganda','+256775804074','UI/UX Design','Canva;Adobe XD;Figma','https://github.com/iragrace2474',NULL,'','Full-time','2026-06-01','Fluent','UTC+3 (EAT / Moscow)','I am a second year student at Mbarara University pursuing Bachelor of Information Technology.','2026-03-14 06:39:49.872241+00',NULL),
  ('b2b600bb-66a9-455e-a4cf-98faf536422e','AKANDINDA JUNIOR','akandindajunior00@gmail.com','Mbarara, Uganda','+256757403227','Motion Graphics & Video','Affinity;Blender;After Effects;Photoshop','',NULL,'https://www.linkedin.com/in/akandinda-junior-240221353','Part-time','2026-03-18','Intermediate','UTC+4','I am a third year student doing software engineering and graphics design.','2026-03-18 09:27:34.424214+00',NULL),
  ('d45bbdf6-bbc6-43e2-b497-777efc34a515','Murungi Kevin Tumaini','kevintumaini90@gmail.com','Mbarara, Uganda','+256767344539','Software Development','JavaScript MySQL Postresql React Node.js;Java;Python C','https://github.com/Tum2um',NULL,'https://www.linkedin.com/in/kevin-tumaini','Full-time','2026-06-06','Fluent','UTC+3 (EAT / Moscow)','I''m a third year Software Engineering student with strong skills in MySQL, PostgreSQL, JavaScript, Node.js and React.','2026-04-20 19:26:45.005557+00',NULL),
  ('d46cc2e8-f709-4bbb-b2c0-7a09e1c23c11','Joronimo Amanya','joronimoamanya@gmail.com','MBARARA, Uganda','+256726128513','Software Development','Typescript React Native;Python;Supabase','https://github.com/joro-nimo',NULL,'https://linkedin.com/profile/joronimoamanya','Full-time','2026-06-08','Fluent','UTC+3 (EAT / Moscow)','Am a community Lead at Blue Ox Kampus.','2026-04-16 05:32:39.844802+00',NULL),
  ('e250e8da-b095-402e-8350-4275d51d3185','GnTV UG','smogdaily@gmail.com','Mbarara','+256200913432','Customer Support','','',NULL,'','Part-time','2026-04-30','Native','UTC+0 (GMT)','Building the next big thing','2026-04-25 10:34:06.220749+00',NULL),
  ('e8efbe44-7a0b-471b-b4a4-ec1b7afc760b','Rwendeire Joshua Truth','rwendeirejoshuatruth@gmail.com','Mbarara , Uganda','+256 743447922','UI/UX Design','figma;Prototyping;Wireframing;figma adobe and capcut','https://github.com/JoshuaTruth',NULL,'https://www.linkedin.com/in/rwendeire-joshua-truth-6559b32b8','Part-time','2026-06-15','Fluent','UTC+3 (EAT / Moscow)','I''m a 2nd year Computer Science Student at Mbarara University, creative designer specializing in Graphics design, UI/UX design and Video Editing.','2026-04-20 19:51:41.762528+00',NULL),
  ('edb7c048-aaa6-412c-8556-487910cf92e4','Ian Abenaitwe','ianabenaitwegoat59@gmail.com','Mbarara Uganda','+256 784161271','Software Development','React;python;Cursor;Codex;Claude code','https://github.com/Abenaitwe',NULL,'','Weekends','2026-03-17','Fluent','UTC+3 (EAT / Moscow)','I''m a first year student at MUST University pursuing Information Technology.','2026-03-10 13:30:55.796357+00',NULL),
  ('f5cbbd51-343d-43fa-b113-db6f263e78ea','Ada Namukasa','admin@picflair.art','Masaka, Uganda','+256 700545121','Motion Graphics & Video','higgsfield;capcut;Figma;After Effects;Premiere Pro','',NULL,'','Full-time','2026-04-01','Fluent','UTC+3 (EAT / Moscow)','I''m a final year CS student with a background in motion graphics, after effects and video graphics.','2026-03-10 11:26:49.651454+00',NULL),
  ('fc1edb07-5c2b-42d7-9aea-27172c064c89','Akello Miracle','miracleayah98@gmail.com','Jinja city, Uganda','+256785139958','Other','Writing','',NULL,'','Full-time','2026-04-20','Fluent','UTC+3 (EAT / Moscow)','I am a high school student who''s in need a job','2026-04-16 14:01:44.837695+00',NULL)
ON CONFLICT (id) DO NOTHING;


-- ─────────────────────────────────────────────
-- 2. STARTUP PROFILES  (keep old Supabase UUID as user_id placeholder)
--    auth/sync will re-link to Clerk ID on first login by email
-- ─────────────────────────────────────────────
INSERT INTO public.startup_profiles (id, user_id, company_name, website, description, industry, team_size, location, email, created_at)
VALUES
  ('0f68898d-ca84-43b3-9dc0-fab6cfe7769a','ba39a542-1e5e-4f4d-a432-d73dced1d9c5','Kingdom broker','kingdombroker.com','Ai agent for EBITDA home owners','Software / SaaS','Solo founder','Washington USA','tryjesusexperiment@gmail.com','2026-04-16 00:45:48.545399+00'),
  ('81cc60e6-6bc4-4bb6-9acc-375d891abc4a','e9015b01-df84-4a8f-b063-8d65e735b3a7','Odd Shoes Dev','oddshoes.dev','We have nothing to say','EdTech','6–15','Uganda','nahabwe.edwin12@gmail.com','2026-04-20 07:14:22.939442+00'),
  ('93ebcb5b-747e-4c24-baf3-ac421c8beba0','8195fb4b-af4a-485b-8926-f34e4500c946','Outside catering','none','Food industry, food and beverages','Other','6–15','Mbarara','judierungi142@gmail.com','2026-04-13 15:06:52.120169+00'),
  ('b7b748bc-be85-4d53-8811-45d0c218b4bd','27ab24c3-a998-47fc-8895-c02cd301b86c','Gold rush','www.goldrush.com','Gaming platform that helps protect children online from predators','E-commerce','Solo founder','Florida, USA','shoemaker.oddshoes@gmail.com','2026-03-21 07:39:10.804143+00'),
  ('b8460b82-6732-43c7-8f38-b9a542767130','2acbd07e-ab74-4d43-b7cb-502f38c62843','inc','','we are software company','','','','akandindajunior00@gmail.com','2026-04-20 06:04:47.570353+00'),
  ('c5d58d76-4b4e-461c-a738-0f6041757b09','6527d836-b8b1-46b1-87fe-fa55e0611408','Acme Inc','https://acme.inc','We''re a Marketing agency and interns will work on videos for our clients.','Marketing / Agency','6–15','Berlin, Germany','plainnotess@gmail.com','2026-03-10 13:19:05.673141+00'),
  ('cef09a82-ea2e-443a-b6d2-6ad3e4102e5a','c0bdb845-f2f5-4a5e-8ebc-937f289a170f','Blue Ox','https://blueoxkampus.com','We''re Uganda''s number 1 AI & VR kampus.','Software / SaaS','6–15','Kampala, Uganda','blueoxrecruit@gmail.com','2026-03-10 20:43:21.438239+00')
ON CONFLICT (id) DO NOTHING;


-- ─────────────────────────────────────────────
-- 3. POD SELECTIONS  (startup_id is old Supabase UUID — re-linked on startup login)
-- ─────────────────────────────────────────────
INSERT INTO public.pod_selections (id, startup_id, startup_email, startup_name, intern_id, confirmed, created_at)
VALUES
  ('0c589947-5741-4113-a0a3-e1966a8fcda7','6527d836-b8b1-46b1-87fe-fa55e0611408','plainnotess@gmail.com','Acme Inc','f5cbbd51-343d-43fa-b113-db6f263e78ea',true,'2026-03-10 14:08:29.866826+00'),
  ('0e03a208-ed32-4031-81be-43e0bdbed647','27ab24c3-a998-47fc-8895-c02cd301b86c','shoemaker.oddshoes@gmail.com','Gold rush','b06af514-969a-48f6-8cde-4ec32b3542e7',true,'2026-03-21 07:41:01.474128+00'),
  ('23d65cb9-cfc0-4cf0-8ad6-2c485f05da30','2acbd07e-ab74-4d43-b7cb-502f38c62843','akandindajunior00@gmail.com','inc','6130c9c5-8d91-48a6-99e9-f4882d09bb80',true,'2026-04-20 06:06:12.42196+00'),
  ('4d61f8d8-6440-4f87-8a78-998711eb2c23','6527d836-b8b1-46b1-87fe-fa55e0611408','plainnotess@gmail.com','Acme Inc','53e2a056-6096-43b3-bb8e-a2e4a6661049',true,'2026-03-10 14:08:33.385869+00'),
  ('4dec9ae2-365e-4d9e-9f7d-63a7e6d98891','6527d836-b8b1-46b1-87fe-fa55e0611408','plainnotess@gmail.com','Acme Inc','edb7c048-aaa6-412c-8556-487910cf92e4',true,'2026-03-10 14:08:35.558844+00'),
  ('6fa3fd68-73cb-47f7-be60-fc193e6b531c','27ab24c3-a998-47fc-8895-c02cd301b86c','shoemaker.oddshoes@gmail.com','Gold rush','71a35df8-d641-44b2-8e16-4516b6da7277',true,'2026-03-21 07:41:08.784312+00'),
  ('cae9800c-33c7-4a1e-93ea-922f3bedd0ca','2acbd07e-ab74-4d43-b7cb-502f38c62843','akandindajunior00@gmail.com','inc','b2b600bb-66a9-455e-a4cf-98faf536422e',true,'2026-04-20 06:06:03.0669+00'),
  ('d78b5d6b-692e-4bb5-b07c-20ca13a7ab83','2acbd07e-ab74-4d43-b7cb-502f38c62843','akandindajunior00@gmail.com','inc','fc1edb07-5c2b-42d7-9aea-27172c064c89',true,'2026-04-20 06:06:17.048219+00'),
  ('fcfd198c-a46e-4740-a8aa-680d9606b413','27ab24c3-a998-47fc-8895-c02cd301b86c','shoemaker.oddshoes@gmail.com','Gold rush','3ba98cf9-6be7-462e-bf8c-fb22f671740d',true,'2026-03-21 07:40:53.157037+00')
ON CONFLICT (id) DO NOTHING;
