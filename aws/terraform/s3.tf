resource "aws_s3_bucket" "bosh" {
    bucket = "shaozhen-bosh"
    acl = "private"
    force_destroy= true

    tags {
        Name = "shaozhen-bosh"
        Environment = "shaozhen"
    }
}

resource "aws_s3_bucket" "buildpacks" {
    bucket = "shaozhen-buildpacks"
    acl = "private"
    force_destroy= true

    tags {
        Name = "shaozhen-buildpacks"
        Environment = "shaozhen"
    }
}

resource "aws_s3_bucket" "droplets" {
    bucket = "shaozhen-droplets"
    acl = "private"
    force_destroy= true

    tags {
        Name = "shaozhen-droplets"
        Environment = "shaozhen"
    }
}

resource "aws_s3_bucket" "packages" {
    bucket = "shaozhen-packages"
    acl = "private"
    force_destroy= true

    tags {
        Name = "shaozhen-packages"
        Environment = "shaozhen"
    }
}

resource "aws_s3_bucket" "resources" {
    bucket = "shaozhen-resources"
    acl = "private"
    force_destroy= true

    tags {
        Name = "shaozhen-resources"
        Environment = "shaozhen"
    }
}
