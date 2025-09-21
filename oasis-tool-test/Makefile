include $(TOPDIR)/rules.mk

PKG_NAME:=oasis-tool-test
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

LUA_OLT_SERVER_DIR=/usr/libexec/rpcd
UCODE_OLT_SERVER_DIR=/usr/share/rpcd/ucode

include $(INCLUDE_DIR)/package.mk

define Package/oasis-tool-test
    CATEGORY:=utakamo
    SECTION:=utakamo
    TITLE:= Oasis Local Tool Server test Package
    DEPENDS:=+oasis-mod-tool
    PKGARCH:=all
endef

define Build/Compile
endef

define Package/oasis-tool-test/install
	$(INSTALL_DIR) $(1)$(LUA_OLT_SERVER_DIR)
	$(INSTALL_DIR) $(1)$(UCODE_OLT_SERVER_DIR)
	$(INSTALL_BIN) ./files/usr/libexec/rpcd/oasis.lua.test.tool $(1)$(LUA_OLT_SERVER_DIR)
	$(INSTALL_DATA) ./files/usr/share/rpcd/ucode/oasis.ucode.test.manager.uc $(1)$(UCODE_OLT_SERVER_DIR)
endef

$(eval $(call BuildPackage,oasis-tool-test))