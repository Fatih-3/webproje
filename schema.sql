-- Veritabanını oluştur
CREATE DATABASE dgs_kocluk;

-- Veritabanına bağlan
\c dgs_kocluk

-- Önce bağımlılığı olmayan tabloları oluştur
-- Kullanicilar tablosu
CREATE TABLE kullanicilar (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    sifre VARCHAR(255) NOT NULL,
    ad VARCHAR(50) NOT NULL,
    soyad VARCHAR(50) NOT NULL,
    telefon VARCHAR(15),
    kayit_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    son_giris TIMESTAMP,
    aktif BOOLEAN DEFAULT true
);

-- Paketler tablosu
CREATE TABLE paketler (
    id SERIAL PRIMARY KEY,
    paket_adi VARCHAR(50) NOT NULL,
    fiyat DECIMAL(10,2) NOT NULL,
    gorusme_sayisi INTEGER NOT NULL,
    destek_suresi VARCHAR(50),
    ozellikler TEXT[],
    aktif BOOLEAN DEFAULT true
);

-- Sonra bağımlı tabloları oluştur
-- Ogrenciler tablosu
CREATE TABLE ogrenciler (
    id SERIAL PRIMARY KEY,
    kullanici_id INTEGER REFERENCES kullanicilar(id),
    ogrenci_no VARCHAR(20),
    bolum VARCHAR(100),
    sinif INTEGER,
    hedef_bolum VARCHAR(100),
    hedef_universite VARCHAR(100),
    baslangic_puani DECIMAL(5,2),
    hedef_puan DECIMAL(5,2),
    kayit_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Koclar tablosu
CREATE TABLE koclar (
    id SERIAL PRIMARY KEY,
    kullanici_id INTEGER REFERENCES kullanicilar(id),
    uzmanlik_alani VARCHAR(100),
    deneyim_yili INTEGER,
    ogrenci_sayisi INTEGER DEFAULT 0,
    puan DECIMAL(3,2) DEFAULT 0,
    aktif BOOLEAN DEFAULT true,
    kayit_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Ogrenci_Koc_Eslesme tablosu
CREATE TABLE ogrenci_koc_eslesme (
    id SERIAL PRIMARY KEY,
    ogrenci_id INTEGER REFERENCES ogrenciler(id),
    koc_id INTEGER REFERENCES koclar(id),
    paket_id INTEGER REFERENCES paketler(id),
    baslangic_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    bitis_tarihi TIMESTAMP,
    aktif BOOLEAN DEFAULT true,
    UNIQUE(ogrenci_id, koc_id)
);

-- Gorusmeler tablosu
CREATE TABLE gorusmeler (
    id SERIAL PRIMARY KEY,
    eslesme_id INTEGER REFERENCES ogrenci_koc_eslesme(id),
    tarih TIMESTAMP NOT NULL,
    sure INTEGER, -- dakika cinsinden
    konu TEXT,
    notlar TEXT,
    durum VARCHAR(20) DEFAULT 'bekliyor' -- bekliyor, tamamlandi, iptal
);

-- Ilerleme_Raporlari tablosu
CREATE TABLE ilerleme_raporlari (
    id SERIAL PRIMARY KEY,
    eslesme_id INTEGER REFERENCES ogrenci_koc_eslesme(id),
    tarih TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    matematik_puani DECIMAL(5,2),
    turkce_puani DECIMAL(5,2),
    genel_puan DECIMAL(5,2),
    calisilan_konular TEXT[],
    notlar TEXT
);

-- Mesajlar tablosu
CREATE TABLE mesajlar (
    id SERIAL PRIMARY KEY,
    gonderen_id INTEGER REFERENCES kullanicilar(id),
    alici_id INTEGER REFERENCES kullanicilar(id),
    mesaj TEXT NOT NULL,
    okundu BOOLEAN DEFAULT false,
    tarih TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Odemeler tablosu
CREATE TABLE odemeler (
    id SERIAL PRIMARY KEY,
    eslesme_id INTEGER REFERENCES ogrenci_koc_eslesme(id),
    tutar DECIMAL(10,2) NOT NULL,
    odeme_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    odeme_durumu VARCHAR(20) DEFAULT 'bekliyor', -- bekliyor, tamamlandi, iptal
    odeme_yontemi VARCHAR(50)
);

-- Koçlar tablosu
CREATE TABLE coaches (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    title VARCHAR(100) NOT NULL,
    image_url TEXT NOT NULL,
    rating DECIMAL(2,1) NOT NULL,
    student_count INTEGER NOT NULL,
    education TEXT NOT NULL,
    dgs_ranking INTEGER NOT NULL,
    experience_years INTEGER NOT NULL,
    success_rate INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Koç hizmetleri tablosu
CREATE TABLE coach_services (
    id SERIAL PRIMARY KEY,
    coach_id INTEGER REFERENCES coaches(id),
    service_name VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Hizmet paketleri tablosu
CREATE TABLE service_packages (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Paket özellikleri tablosu
CREATE TABLE package_features (
    id SERIAL PRIMARY KEY,
    package_id INTEGER REFERENCES service_packages(id),
    feature_description TEXT NOT NULL,
