import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  /* config options here */
  // 开发环境配置
  ...(process.env.NODE_ENV === 'development' && {
    // 启用热重载
    webpack: (config, { dev, isServer }) => {
      if (dev && !isServer) {
        // 配置文件监听
        config.watchOptions = {
          poll: 1000,
          aggregateTimeout: 300,
        };
      }
      return config;
    },
    // 开发服务器配置
    devIndicators: {
      position: 'bottom-right',
    },
  }),
};

export default nextConfig;
