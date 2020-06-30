OPTEE_GET_TIME_VERSION = 1.0
OPTEE_GET_TIME_SOURCE = local
OPTEE_GET_TIME_SITE = $(BR2_PACKAGE_OPTEE_GET_TIME_SITE)
OPTEE_GET_TIME_SITE_METHOD = local
OPTEE_GET_TIME_INSTALL_STAGING = YES
OPTEE_GET_TIME_DEPENDENCIES = optee_client host-python-pycrypto
OPTEE_GET_TIME_SDK = $(BR2_PACKAGE_OPTEE_GET_TIME_SDK)
OPTEE_GET_TIME_CONF_OPTS = -DOPTEE_GET_TIME_SDK=$(OPTEE_GET_TIME_SDK)

define OPTEE_GET_TIME_BUILD_TAS
	@for f in $(@D)/*/ta/Makefile; \
	do \
	  echo Building $$f && \
			$(MAKE) CROSS_COMPILE="$(shell echo $(BR2_PACKAGE_OPTEE_GET_TIME_CROSS_COMPILE))" \
			O=out TA_DEV_KIT_DIR=$(OPTEE_GET_TIME_SDK) \
			$(TARGET_CONFIGURE_OPTS) -C $${f%/*} all; \
	done
endef

define OPTEE_GET_TIME_INSTALL_TAS
	@$(foreach f,$(wildcard $(@D)/*/ta/out/*.ta), \
		mkdir -p $(TARGET_DIR)/lib/optee_armtz && \
		$(INSTALL) -v -p  --mode=444 \
			--target-directory=$(TARGET_DIR)/lib/optee_armtz $f \
			&&) true
endef

OPTEE_GET_TIME_POST_BUILD_HOOKS += OPTEE_GET_TIME_BUILD_TAS
OPTEE_GET_TIME_POST_INSTALL_TARGET_HOOKS += OPTEE_GET_TIME_INSTALL_TAS

$(eval $(cmake-package))