//
//  UUImage.swift
//  UUSwift
//
//  Created by Jonathan Hays on 12/11/18.
//  Copyright © 2018 Jonathan Hays. All rights reserved.
//

#if os(macOS)
	import AppKit
	public typealias UUImage = NSImage
#else
	import UIKit
	public typealias UUImage = UIImage
#endif

import UUSwiftCore

public extension UUImage
{
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: - Resizing functions
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	func uuCropToSize(targetSize : CGSize, useScreenScale : Bool = false) -> UUImage
	{
		var thumbnailRect : CGRect = .zero
		thumbnailRect.origin = CGPoint(x: 0, y: 0)
		thumbnailRect.size = CGSize(width: self.size.width, height: self.size.height)
		
		return self.uuPlatformDraw(targetSize : targetSize, thumbnailRect : thumbnailRect, scale: useScreenScale ? UUImage.uuScreenScale() : 1.0)
	}
	
	
	func uuScaleToSize(targetSize : CGSize, useScreenScale : Bool = false) -> UUImage
	{
		let imageSize = self.size
		let width : CGFloat = imageSize.width
		let height : CGFloat = imageSize.height
		
		let targetWidth : CGFloat = targetSize.width
		let targetHeight : CGFloat = targetSize.height
		
		var scaleFactor : CGFloat = 0.0
		var scaledWidth : CGFloat = targetWidth
		var scaledHeight : CGFloat = targetHeight
		
		var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
		
		if imageSize != targetSize
		{
			let widthFactor : CGFloat = targetWidth / width
			let heightFactor : CGFloat = targetHeight / height
			
			if widthFactor < heightFactor
			{
				scaleFactor = widthFactor
			}
			else
			{
				scaleFactor = heightFactor
			}
			
			scaledWidth = width * scaleFactor
			scaledHeight = height * scaleFactor
			
			if (widthFactor < heightFactor)
			{
				thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
			}
			else if (widthFactor > heightFactor)
			{
				thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
			}
		}
		
		var thumbnailRect : CGRect = .zero
		thumbnailRect.origin = thumbnailPoint
		thumbnailRect.size.width = scaledWidth
		thumbnailRect.size.height = scaledHeight
		
		return self.uuPlatformDraw(targetSize : targetSize, thumbnailRect : thumbnailRect, scale: useScreenScale ? UUImage.uuScreenScale() : 1.0)
	}
	
	func uuScaleAndCropToSize(targetSize : CGSize, useScreenScale : Bool = false) -> UUImage
	{
		let sourceImage = self
		let imageSize = sourceImage.size
		var scaleFactor : CGFloat = 0.0
		var scaledWidth : CGFloat = targetSize.width
		var scaledHeight : CGFloat = targetSize.height
		var thumbnailPoint = CGPoint(x: 0.0, y: 0.0)
		
		if (imageSize != targetSize)
		{
			let widthFactor = targetSize.width / imageSize.width
			let heightFactor = targetSize.height / imageSize.height
			if (widthFactor > heightFactor)
			{
				scaleFactor = widthFactor
			}
			else
			{
				scaleFactor = heightFactor
			}
			
			scaledWidth = imageSize.width * scaleFactor
			scaledHeight = imageSize.height * scaleFactor
			
			if (widthFactor > heightFactor)
			{
                thumbnailPoint.y = (targetSize.height - scaledHeight) * 0.5
			}
			else if (widthFactor < heightFactor)
			{
				thumbnailPoint.x = (targetSize.width - scaledWidth) * 0.5
			}
		}
				
		var thumbnailRect : CGRect = .zero
		thumbnailRect.origin = thumbnailPoint
		thumbnailRect.size = CGSize(width: scaledWidth, height: scaledHeight)
		
		return self.uuPlatformDraw(targetSize: targetSize, thumbnailRect : thumbnailRect, scale: useScreenScale ? UUImage.uuScreenScale() : 1.0)
	}
	
	
	func uuScaleToWidth(targetWidth: CGFloat) -> UUImage
	{
		let destSize = self.uuCalculateScaleToWidth(width: targetWidth)
		return self.uuScaleToSize(targetSize: destSize)
	}
	
	func uuScaleToHeight(targetHeight : CGFloat) -> UUImage
	{
		let destSize = self.uuCalculateScaleToHeight(height: targetHeight)
		return self.uuScaleToSize(targetSize: destSize)
	}
	
	func uuScaleSmallestDimensionToSize(size : CGFloat) -> UUImage
	{
		if (self.size.width < self.size.height)
		{
			return self.uuScaleToWidth(targetWidth: size)
		}
		else
		{
			return self.uuScaleToHeight(targetHeight : size)
		}
	}
	
	func uuPngData() -> Data? {
		return self.uuPlatformPngData()
	}
	
	func uuJpegData(_ compressionQuality: CGFloat) -> Data? {
		return self.uuPlatformJpegData(compressionQuality)
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: - Private helper functions
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private func uuCalculateScaleToFitDestSize(size : CGFloat) -> CGSize
	{
		if self.size.width < self.size.height
		{
			return self.uuCalculateScaleToWidth(width:size)
		}
		else
		{
			return self.uuCalculateScaleToHeight(height:size)
		}
	}
	
	private static func uuCalculateScaleToWidthDestSize(width : CGFloat, srcSize : CGSize) -> CGSize
	{
		let srcWidth = srcSize.width
		let srcHeight = srcSize.height
		let srcAspectRatio = srcHeight / srcWidth
		
		let targetHeight = width * srcAspectRatio
		
		return CGSize(width: width, height: targetHeight)
	}
	
	private static func uuCalculateScaleToHeightDestSize(height : CGFloat, srcSize : CGSize) -> CGSize
	{
		let srcWidth = srcSize.width
		let srcHeight = srcSize.height
		let srcAspectRatio = srcWidth / srcHeight
		
		let targetWidth = height * srcAspectRatio
		
		return CGSize(width: targetWidth, height: height)
	}
	
	private func uuCalculateScaleToWidth(width : CGFloat) -> CGSize
	{
		return UUImage.uuCalculateScaleToWidthDestSize(width: width, srcSize: self.size)
	}
	
	private func uuCalculateScaleToHeight(height : CGFloat) -> CGSize
	{
		return UUImage.uuCalculateScaleToHeightDestSize(height: height, srcSize: self.size)
	}

	
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: - iOS implementation
	/////////////////////////////////////////////////////////////////////////////////////////////////////////

	#if os(iOS) || os(tvOS)

	private func uuPlatformPngData() -> Data? {
		return self.pngData()
	}
	
	private func uuPlatformJpegData(_ compressionQuality: CGFloat) -> Data? {
		return self.jpegData(compressionQuality: compressionQuality)
	}

	private func uuPlatformDraw(targetSize : CGSize, thumbnailRect : CGRect, scale : CGFloat = 1.0) -> UUImage
	{
		UIGraphicsBeginImageContextWithOptions(targetSize, false, scale)

		self.draw(in: thumbnailRect)
		
		if let newImage = UIGraphicsGetImageFromCurrentImageContext()
		{
			UIGraphicsEndImageContext()
			return newImage
		}
		
		return self
	}

	private static func uuScreenScale() -> CGFloat
	{
		return UIScreen.main.scale
	}

	#else
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: - Mac implementation
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	private func uuPlatformPngData() -> Data? {
		
		var imageRect = CGRect(origin: .zero, size: self.size)
		
		if let cgImage = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
		{
			let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
			bitmapRep.size = self.size
			if let data = bitmapRep.representation(using: .png, properties: [:])
			{
				return data
			}
		}
		
		return nil
	}
	
	private func uuPlatformJpegData(_ compressionQuality: CGFloat) -> Data? {
		
		var imageRect = CGRect(origin: .zero, size: self.size)
		
		if let cgImage = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
		{
			let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
			bitmapRep.size = self.size
			if let data = bitmapRep.representation(using: .jpeg, properties: [NSBitmapImageRep.PropertyKey.compressionFactor: compressionQuality])
			{
				return data
			}
		}
		
		return nil
	}
	
	private func uuPlatformDraw(targetSize : CGSize, thumbnailRect : CGRect, scale : CGFloat = 1.0) -> UUImage
	{
		guard let representation = self.bestRepresentation(for: thumbnailRect, context: nil, hints: nil) else {
			return self
		}
		
		let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
			return representation.draw(in: thumbnailRect)
		})
		
		return image
	}

	private static func uuScreenScale() -> CGFloat
	{
		return 1.0
	}
	
	#endif
	
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Mac specific functions
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#if os(macOS)
extension UUImage {

	func pngData()->Data? {
		
		if let tiff = self.tiffRepresentation,
		   let tiffData = NSBitmapImageRep(data: tiff)
		{
			return tiffData.representation(using: .png, properties: [:])
		}
		
		return nil
	}
	
	func jpegData(compressionQuality : CGFloat)->Data? {
		
		if let tiff = self.tiffRepresentation,
			let tiffData = NSBitmapImageRep(data: tiff)
		{
			return tiffData.representation(using: .jpeg, properties: [:])
		}
		
		return nil
	}
}
#endif

	


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MARK: - iOS specific functions
////////////////////////////////////////////////////////////////////////////////////////////////////////////
#if os(iOS)

public extension UIImage {

	var uuAverageColor: UIColor? {
		guard let inputImage = CIImage(image: self) else { return nil }
		let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

		guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
		guard let outputImage = filter.outputImage else { return nil }

		var bitmap = [UInt8](repeating: 0, count: 4)
		let context = CIContext(options: [.workingColorSpace: kCFNull!])
		context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

		return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
	}


	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: - Solid color image functions
	/////////////////////////////////////////////////////////////////////////////////////////////////////////

	static func uuSolidColorImage(color : UIColor) -> UUImage?
	{
		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
	
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
	
		context?.setFillColor(color.cgColor)
		context?.fill(rect)
	
		if let image = UIGraphicsGetImageFromCurrentImageContext()
		{
			UIGraphicsEndImageContext()
		
			return image
		}
	
		return nil
	}

	static func uuSolidColorImage(color : UUColor, cornerRadius : CGFloat, borderColor : UIColor, borderWidth : CGFloat) -> UUImage?
	{
		let rect = CGRect(x: 0.0, y: 0.0, width: 2.0 * ((cornerRadius * 2.0) + 1), height: 2.0 * ((cornerRadius * 2.0) + 1))
		let view = UIView(frame: rect)
		view.backgroundColor = color
		view.layer.borderColor = borderColor.cgColor
		view.layer.cornerRadius = cornerRadius
		view.layer.masksToBounds = true
		view.layer.borderWidth = borderWidth
		if let image = UIImage.uuViewToImage(view)
		{
			return image.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
		}
	
		return nil
	}

	func uuMakeMaskedImage(mask:(UIImage))->UIImage? {

		if let imageReference = self.cgImage,
		   let maskReference = mask.cgImage,
		   let maskDataProvider = maskReference.dataProvider {

			if let imageMask = CGImage(maskWidth: maskReference.width,
									   height: maskReference.height,
									   bitsPerComponent: maskReference.bitsPerComponent,
									   bitsPerPixel: maskReference.bitsPerPixel,
									   bytesPerRow: maskReference.bytesPerRow,
									   provider: maskDataProvider, decode: nil, shouldInterpolate: true)
			{
				let maskedReference = imageReference.masking(imageMask)
				let maskedImage = UIImage(cgImage:maskedReference!)
				return maskedImage
			}
		}

		return nil
	}

	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: - Animated GIF support
	/////////////////////////////////////////////////////////////////////////////////////////////////////////

	static func uuGIFImage(named : String) -> UIImage? {
		if let filePath = Bundle.main.path(forResource: named, ofType: "gif"),
			let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
		{
			return uuImageWithGIFData(data)
		}

		return nil
	}

	static func uuImageWithGIFData(_ data : Data) -> UIImage? {
		var image : UIImage? = nil
		if let imageRef = CGImageSourceCreateWithData(data as CFData, nil) {
			let frameCount = CGImageSourceGetCount(imageRef)
			let duration = UIImage.uuGIFDuration(imageRef, count: frameCount)
			let frames = UIImage.uuCreateGIFFrames(imageRef, count: frameCount)
			image = UIImage.animatedImage(with: frames, duration: duration)
		}
		
		return image
	}
	
	private static func uuCreateGIFFrames(_ source : CGImageSource, count : Int) -> [UIImage] {
		var frames : [UIImage] = []
		
		for i in 0...count - 1 {
			if let imageRef = CGImageSourceCreateImageAtIndex(source, i, nil) {
				let image = UIImage(cgImage: imageRef)
				frames.append(image)
			}
		}
		
		return frames
	}
	
	private static func uuGIFDuration(_ source : CGImageSource, count : Int) -> TimeInterval {
		var duration : TimeInterval = 0.0
		
		for i in 0...count - 1 {
			if let dictionary = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? Dictionary<String, Any> {
				if let properties = dictionary[kCGImagePropertyGIFDictionary as String] as? Dictionary<String, Any> {
					if let length = properties[kCGImagePropertyGIFDelayTime as String] as? NSNumber {
						duration = duration + length.doubleValue
					}
				}
			}
		}
		
		return duration
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	// MARK: - Misc
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	func uuRemoveOrientation() -> UUImage {
		if self.imageOrientation == .up
		{
			return self
		}
	
		var affineTransformation : CGAffineTransform = .identity
	
		switch self.imageOrientation
		{
			case .up, .upMirrored:
			break
		
			case .down, .downMirrored:
				affineTransformation = affineTransformation.translatedBy(x: self.size.width, y: self.size.height)
				affineTransformation = affineTransformation.rotated(by: .pi)
			break
		
			case .left, .leftMirrored:
				affineTransformation = affineTransformation.translatedBy(x: self.size.width, y: 0.0)
				affineTransformation = affineTransformation.rotated(by: 2.0 * .pi)
			break
		
			case .right, .rightMirrored:
				affineTransformation = affineTransformation.translatedBy(x: 0.0, y: self.size.height)
				affineTransformation = affineTransformation.rotated(by: -2.0 * .pi)
			break
			
			@unknown default:
			break
		}
	
		if (self.imageOrientation == .upMirrored || self.imageOrientation == .downMirrored)
		{
			affineTransformation = affineTransformation.translatedBy(x: self.size.width, y: 0.0)
			affineTransformation = affineTransformation.scaledBy(x: -1.0, y: 1.0)
		}
		if (self.imageOrientation == .leftMirrored || self.imageOrientation == .rightMirrored)
		{
			affineTransformation = affineTransformation.translatedBy(x: self.size.height, y: 0.0)
			affineTransformation = affineTransformation.scaledBy(x: -1.0, y: 1.0)
		}
	
		let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		
		if let cgImageRef = self.cgImage,
		   let contextRef = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
		{
			contextRef.concatenate(affineTransformation)
		
			if (self.imageOrientation == .left ||
				self.imageOrientation == .leftMirrored ||
				self.imageOrientation == .right ||
				self.imageOrientation == .rightMirrored)
			{
				contextRef.draw(cgImageRef, in: CGRect(x: 0.0, y: 0.0, width: self.size.height, height: self.size.width))
			}
			else
			{
				contextRef.draw(cgImageRef, in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
			}
		
			if let imageRef = contextRef.makeImage()
			{
				return UIImage(cgImage: imageRef)
			}
		}
	
		return self
	}


	static func uuViewToImage(_ view : UIView) -> UIImage?
	{
		UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
		if let outputContext = UIGraphicsGetCurrentContext()
		{
			view.layer.render(in: outputContext)
			
			if let image = UIGraphicsGetImageFromCurrentImageContext()
			{
				UIGraphicsEndImageContext()
				return image
			}
		}
	
		return nil
	}

	static func uuMakeStretchableImage(imageName : String, insets : UIEdgeInsets) -> UIImage?
	{
		return UIImage(named: imageName)?.resizableImage(withCapInsets: insets)
	}

}
#endif
