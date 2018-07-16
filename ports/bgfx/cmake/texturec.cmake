# Expose bimg::texturec as bgfx::texturec
if(TARGET texturec)
  add_executable(bgfx::texturec ALIAS texturec)
elseif(TARGET texturec)
  add_executable(bgfx::texturec ALIAS bimg::texturec)
endif()
