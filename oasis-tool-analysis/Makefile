include $(TOPDIR)/rules.mk

PKG_NAME:=oasis-tool-analysis
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

LUA_OLT_SERVER_DIR=/usr/libexec/rpcd

include $(INCLUDE_DIR)/package.mk

define Package/oasis-tool-analysis
    CATEGORY:=utakamo
    SECTION:=utakamo
    TITLE:= Oasis Local Tool Server Analysis Package
    DEPENDS:=+oasis-mod-tool +gpiod-tools
    PKGARCH:=all
endef

define Build/Compile
endef

define Package/oasis-tool-analysis/install
	$(INSTALL_DIR) $(1)$(LUA_OLT_SERVER_DIR)
	$(INSTALL_BIN) ./files/usr/libexec/rpcd/analysis.tool $(1)$(LUA_OLT_SERVER_DIR)
endef

$(eval $(call BuildPackage,oasis-tool-analysis))