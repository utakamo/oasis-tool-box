include $(TOPDIR)/rules.mk

PKG_NAME:=oasis-tool-wireguard
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

LUA_OLT_SERVER_DIR=/usr/libexec/rpcd
UCODE_OLT_SERVER_DIR=/usr/share/rpcd/ucode

include $(INCLUDE_DIR)/package.mk

define Package/oasis-tool-wireguard
    CATEGORY:=utakamo
    SECTION:=utakamo
    TITLE:= Oasis Local Tool Server Template Package
    DEPENDS:=+oasis-mod-tool
    PKGARCH:=all
endef

define Build/Compile
endef

define Package/oasis-tool-wireguard/install
	$(INSTALL_DIR) $(1)$(LUA_OLT_SERVER_DIR)
	$(INSTALL_DIR) $(1)$(UCODE_OLT_SERVER_DIR)
	$(INSTALL_BIN) ./files/usr/libexec/rpcd/wireguard.tool $(1)$(LUA_OLT_SERVER_DIR)
endef

$(eval $(call BuildPackage,oasis-tool-wireguard))