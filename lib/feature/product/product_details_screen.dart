import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/custom_button.dart';
import 'package:getdash/components/footer_section.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/feature/product/widget/product_details_section.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';



class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    double screenWidth = Get.width;

    return Scaffold(
      drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer():null,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            if (ResponsiveHelper.isDesktop(context))
              const MenuDrawer(),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeDefault,
                            horizontal: Dimensions.paddingSizeDefault),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const ProductDetailsSection(),
                                    const SizedBox(height: Dimensions.paddingSizeDefault),
                                    Row(
                                      children: [
                                        Flexible(flex: 2,child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                          Container(
                                              height: 400,
                                              width: screenWidth,
                                              decoration: const BoxDecoration(color: Color(0xffD9D9D9)),
                                              child: Image.asset(Images.productImage,fit: BoxFit.cover),
                                          ),
                                          const SizedBox(height: Dimensions.paddingSizeLarge),
                                          SizedBox(
                                            height: 60,
                                            child: ListView.builder(
                                                itemCount: 3,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (item, context){
                                                  return Padding(
                                                    padding: const EdgeInsets.all(8.0), 
                                                    child: Container(
                                                        height: 50, 
                                                        width: 60, 
                                                        decoration: const BoxDecoration(color: Color(0xffD9D9D9)), 
                                                        child: Image.asset(Images.productImage,fit: BoxFit.cover)),
                                              );
                                            }),
                                          ),
                                        ])),
                                        const SizedBox(width: Dimensions.paddingSizeExtraMoreLarge),
                                        Flexible(
                                            flex: 4,
                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                                              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                                                const Text("Montes Scelerisque"),
                                                if(ResponsiveHelper.isDesktop(context))
                                                Expanded(
                                                  child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Icon(Icons.favorite,color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.5),size: Dimensions.iconSizeSmall),
                                                        const SizedBox(width: Dimensions.paddingSizeSmall, ),
                                                        Icon(Icons.share,size: Dimensions.iconSizeSmall, color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.5),),
                                                        const SizedBox(width: Dimensions.paddingSizeSmall, ),
                                                        Icon(Icons.facebook,size: Dimensions.iconSizeSmall, color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.5),),
                                                        const SizedBox(width: Dimensions.paddingSizeSmall),
                                                        Image.asset(Images.pinterestImage,height: Dimensions.paddingSizeLarge,width: Dimensions.paddingSizeLarge,),
                                                        const SizedBox(width: Dimensions.paddingSizeSmall),
                                                        Image.asset(Images.linkedinImage,height: Dimensions.paddingSizeLarge,width: Dimensions.paddingSizeLarge,),
                                                       ]),
                                                ),
                                          ]),
                    
                                              if(!ResponsiveHelper.isDesktop(context))
                                                Padding(
                                                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                                                  child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Icon(Icons.favorite,color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.5),size: Dimensions.iconSizeSmall),
                                                        const SizedBox(width: Dimensions.paddingSizeSmall, ),
                                                        Icon(Icons.share,size: Dimensions.iconSizeSmall, color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.5),),
                                                        const SizedBox(width: Dimensions.paddingSizeSmall, ),
                                                        Icon(Icons.facebook,size: Dimensions.iconSizeSmall, color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.5),),
                                                        const SizedBox(width: Dimensions.paddingSizeSmall),
                                                        Image.asset(Images.pinterestImage,height: Dimensions.paddingSizeLarge,width: Dimensions.paddingSizeLarge,),
                                                        const SizedBox(width: Dimensions.paddingSizeSmall),
                                                        Image.asset(Images.linkedinImage,height: Dimensions.paddingSizeLarge,width: Dimensions.paddingSizeLarge,),
                                                      ]),
                                                ),
                                              const SizedBox(height: Dimensions.paddingSizeLarge),
                                               Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                    
                                                    Row(children: List.generate(5, (index) => const Icon(Icons.star,size: Dimensions.iconSizeSmall),)),
                                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                                    const Text("5"),
                                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                                    const Text("778 Reviews")
                                                  ]
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeSmall),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("brand".tr),
                                                    const Text(":"),
                                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                    Text("Chair",style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall))
                                                  ]
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    const Text("\$"),
                                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                    Text("250",style: ubuntuBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeSmall))
                                                  ]
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeSmall),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("\$650",style: TextStyle(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),decoration: TextDecoration.lineThrough)),
                                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                    Text("30% off",style: ubuntuMedium.copyWith(color:Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),fontSize: Dimensions.fontSizeExtraSmall))
                                                  ]
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeLarge),
                                              const Text("Lorem ipsum dolor sit amet, consetetur sadipscing elitr,sed diam nonumy eirmod tempor invidunt ut labore et dolore magna."),
                                              const SizedBox(height: Dimensions.paddingSizeLarge),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("available".tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                                    const Text(":"),
                                                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                                                    Text("in_stock".tr,style: ubuntuBold.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),fontSize: Dimensions.fontSizeExtraSmall))
                                                  ]
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeSmall),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("shipping".tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                                    const Text(":"),
                                                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                                                    Text("free".tr,style: ubuntuBold.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),fontSize: Dimensions.fontSizeExtraSmall))
                                                  ]
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeSmall),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("quantity".tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                                    const Text(":"),
                                                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                                                    Row(children: [
                                                      Container(
                                                          color: Theme.of(context).primaryColor.withOpacity(0.06),
                                                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall,),
                                                          child: const Icon(Icons.remove),
                                                      ),
                                                      const SizedBox(width: Dimensions.paddingSizeDefault),
                                                      Text("1",style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                                      const SizedBox(width: Dimensions.paddingSizeDefault),
                                                      Container(
                                                        color: Theme.of(context).primaryColor.withOpacity(0.06),
                                                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall,),
                                                        child: const Icon(Icons.add),
                                                      ),
                                                    ]),
                                                  ]
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeSmall),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("size".tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                                    const Text(":"),
                                                    const SizedBox(width: Dimensions.paddingSizeDoubleExtraLarge),
                                                    Row(children: [
                                                      Container(
                                                        color: Theme.of(context).primaryColor.withOpacity(0.06),
                                                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge,right: Dimensions.paddingSizeLarge,top: Dimensions.paddingSizeSmall,bottom: Dimensions.paddingSizeSmall),
                                                        child: Text("L",style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                                      ),
                                                      const SizedBox(width: Dimensions.paddingSizeDefault),
                                                      Container(
                                                        color: Theme.of(context).primaryColor.withOpacity(0.06),
                                                        padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge,right: Dimensions.paddingSizeLarge,top: Dimensions.paddingSizeSmall,bottom: Dimensions.paddingSizeSmall),
                                                        child: Text("M",style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                                      ),
                                                    ]),
                                                  ]
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeSmall),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("category".tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                                    const Text(":"),
                                                    const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                                                    Text("furniture".tr,style: ubuntuBold.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),fontSize: Dimensions.fontSizeExtraSmall))
                                                  ]
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeSmall),
                                              Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("tags".tr,style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                                                    const Text(":"),
                                                    const SizedBox(width: Dimensions.paddingSizeExtraMoreLarge),
                                                    Text("Blue,Green,Light".tr,style: ubuntuBold.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),fontSize: Dimensions.fontSizeExtraSmall))
                                                  ]
                                              ),
                                              const SizedBox(height: Dimensions.paddingSizeLarge),
                                              Column(
                                                children: [
                                                  Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                          Expanded(child: CustomButton(buttonText: "buy_now".tr,height: Dimensions.buttonSize, fontSize: Dimensions.fontSizeSmall)),
                                                          const SizedBox(width: Dimensions.paddingSizeDefault),

                                                        if(ResponsiveHelper.isDesktop(context))
                                                        CustomButton(
                                                            buttonText: "add_to_cart".tr,
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            height:Dimensions.buttonSize,
                                                            onPressed: () {}),

                                                      ]),
                                                  if(ResponsiveHelper.isMobile(context))
                                                  Expanded(
                                                    child: CustomButton(
                                                        buttonText: "add_to_cart".tr,
                                                        fontSize: Dimensions.fontSizeSmall,
                                                        height:Dimensions.buttonSize,
                                                        onPressed: () {}),
                                                  ),
                                                ],
                                              ),
                                        ])),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeExtraMoreLarge,),
                            const FooterSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

