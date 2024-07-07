create table if not exists auth (
    id uuid primary key not null default uuid_generate_v4(),
    created_at timestamp with time zone default current_timestamp not null,
    updated_at timestamp with time zone default current_timestamp not null,
    phone text not null,
    password text not null,

    unique (phone)
);

create table if not exists users (
    id uuid primary key not null references auth(id) on delete cascade,
    created_at timestamp with time zone default current_timestamp not null,
    updated_at timestamp with time zone default current_timestamp not null,
    name text not null,
	phone text not null,
	email text not null,
	photo_url text default null,

    unique (phone)
);

create table if not exists products (
    id uuid primary key not null default uuid_generate_v4(),
    created_at timestamp with time zone default current_timestamp not null,
    updated_at timestamp with time zone default current_timestamp not null,
    created_by uuid not null references users(id) on delete cascade,
    name text not null,
	category text not null,
	description text not null,
	price int not null,
	used boolean not null default false,
	specifications jsonb default null
);

create table if not exists product_images (
	id uuid not null primary key default uuid_generate_v4(),
	created_at timestamp with time zone default current_timestamp,
	updated_at timestamp with time zone default current_timestamp,
	product_id uuid not null references products(id) on delete cascade,
	file_name text not null,
	url text not null,
	size int not null default 0,
	storage_path text not null,
	content_type text not null
)

create table if not exists favourite_products (
	id uuid not null primary key default uuid_generate_v4(),
	created_at timestamp with time zone default current_timestamp,
	updated_at timestamp with time zone default current_timestamp,
	created_by uuid not null references users(id) on delete cascade,
	product_id uuid not null references products(id) on delete cascade,

	unique (product_id, created_by)
)

create table if not exists chat_rooms (
	id uuid not null primary key default uuid_generate_v4(),
	created_at timestamp with time zone default current_timestamp,
	updated_at timestamp with time zone default current_timestamp,
	participant1 uuid not null references users(id) on delete cascade,
	participant2 uuid not null references users(id) on delete cascade,
	unique (participant1, participant2)
)
create unique index on chat_rooms (least(participant1, participant2), greatest(participant1, participant2));

create table if not exists chat_messages (
	id uuid not null primary key default uuid_generate_v4(),
	created_at timestamp with time zone default current_timestamp,
	updated_at timestamp with time zone default current_timestamp,
	chat_room_id uuid not null references chat_rooms(id) on delete cascade,
	sent_by uuid not null references users(id) on delete cascade,
	message text not null
)
