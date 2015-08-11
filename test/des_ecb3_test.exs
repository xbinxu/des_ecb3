defmodule DesEcb3Test do
  use ExUnit.Case

  @cipher ~s{2bIw8OksByLYT/WX6bQCuxxf41EGL5ugYd3AGHdcLb8cGGLqL2/DhOPTsems/DEttww7yhenMOIspd6ebOQ3K0Q+A9JDcyCES3K8wFsPvO9dh1PF4Kye544ph8KOBDLMwTPqWPGaw1c8/N2xiRW5+SDotxuqsfRV8Ft5P32IAuHqX6g9+Vh0RMx57Bq8bbfgSrqZwm0t11Ev6cZsUcGldZGln+NdclGOi5l94aRhLmWRvsPjrL+SnSsK7SkToVdumTYYCIayUfReJPET4osPdcsFrRl+6Bk7mknogRQms7e63f755pScPpsdmZ8QUiy9gSEEMkYrFOLZgBhqXz91KMTHMl5vYsUWtMY3L4pKebjwqHkpYR5H3n2XNYM8W4Je}
  @key    "p7l2EsADNmV92qTBuRowb8Aj"

  test "the truth" do
    IO.inspect DesEcb3.decrypt(@key, @cipher |> Base.decode64!)
  end
end
