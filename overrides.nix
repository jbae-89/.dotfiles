{ nixpkgs, geopkgs }:

let
  overridesFn = import "${geopkgs.outPath}/overrides.nix";
  pythonVersion = "python311";
  postgresqlVersion = "postgresql";

  overrides = overridesFn {
    inherit nixpkgs geopkgs pythonVersion postgresqlVersion;
  };

  gdalWithECW = (geopkgs.gdal.overrideAttrs (_: {})).override {
    inherit (overrides) geos libgeotiff libspatialite proj tiledb;
    useECW = true;
    useJava = false;
  };

in overrides // {
  gdal = gdalWithECW;
  qgis = geopkgs.qgis.override {
    qgis-unwrapped = (geopkgs.qgis-unwrapped.overrideAttrs (_: {})).override {
      inherit (overrides) geos libspatialindex libspatialite pdal proj;
      gdal = gdalWithECW;
      python3 = overrides.qgis-python;
    };
  };
}