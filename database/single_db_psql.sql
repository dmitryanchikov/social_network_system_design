CREATE TABLE "subscriptions" (
  "following_user_id" uuid,
  "followed_user_id" uuid,
  "created_at" timestamp
);

CREATE TABLE "users" (
  "id" uuid PRIMARY KEY,
  "username" varchar,
  "role" varchar,
  "created_at" timestamp
);

CREATE TABLE "posts" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid,
  "title" varchar,
  "text" text,
  "location_id" uuid,
  "created_at" timestamp
);

CREATE TABLE "reactions" (
  "user_id" uuid,
  "id" uuid PRIMARY KEY,
  "post_id" uuid,
  "comment_id" uuid,
  "reaction_type" integer,
  "created_at" timestamp
);

CREATE TABLE "comments" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid,
  "post_id" uuid,
  "comment_id" uuid,
  "created_at" timestamp
);

CREATE TABLE "attachments" (
  "id" uuid PRIMARY KEY,
  "user_id" uuid,
  "post_id" uuid,
  "comment_id" uuid,
  "url" varchar,
  "size" int,
  "created_at" timestamp
);

CREATE TABLE "locations" (
  "id" uuid PRIMARY KEY,
  "created_at" timestamp,
  "geometry" geometry
);

CREATE TABLE "blob_storage" (
  "data" binary
);

COMMENT ON COLUMN "posts"."text" IS 'Content of the post';

ALTER TABLE "posts" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "subscriptions" ADD FOREIGN KEY ("following_user_id") REFERENCES "users" ("id");

ALTER TABLE "subscriptions" ADD FOREIGN KEY ("followed_user_id") REFERENCES "users" ("id");

ALTER TABLE "reactions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "comments" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "reactions" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("id");

ALTER TABLE "comments" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("id");

ALTER TABLE "reactions" ADD FOREIGN KEY ("comment_id") REFERENCES "comments" ("id");

ALTER TABLE "comments" ADD FOREIGN KEY ("comment_id") REFERENCES "comments" ("id");

ALTER TABLE "attachments" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

ALTER TABLE "attachments" ADD FOREIGN KEY ("post_id") REFERENCES "posts" ("id");

ALTER TABLE "attachments" ADD FOREIGN KEY ("comment_id") REFERENCES "comments" ("id");

ALTER TABLE "posts" ADD FOREIGN KEY ("location_id") REFERENCES "locations" ("id");

ALTER TABLE "attachments" ADD FOREIGN KEY ("url") REFERENCES "blob_storage" ("data");
